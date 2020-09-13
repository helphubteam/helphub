# frozen_string_literal: true

module Api
  class HelpRequestPresenter
    FULL_ATTRIBUTES = %i[id phone state comment number person mediated meds_preciption_required volunteer_id].freeze

    NON_PERSONAL_ATTRIBUTES = %i[id state comment number mediated meds_preciption_required volunteer_id].freeze

    def initialize(target, current_user)
      @target = target
      @current_user = current_user
    end

    def call
      return full_data if (target.volunteer == current_user) && target.assigned?

      non_personal_data
    end

    private

    def non_personal_data
      target.attributes.slice(*NON_PERSONAL_ATTRIBUTES.map(&:to_s))
            .merge(
              address: non_personal_address,
              detailed_address: detailed_non_personal_address,
              lonlat: render_lonlat(target.lonlat_with_salt_geojson),
              distance: distance_label(target),
              geo_salt: true,
              custom_fields: custom_fields,
              date_begin: timestamp(target.date_begin),
              date_end: timestamp(target.date_end),
              created_at: timestamp(target.created_at),
              updated_at: timestamp(target.updated_at)
            )
    end

    def full_data
      target.attributes.slice(*FULL_ATTRIBUTES.map(&:to_s))
            .merge(
              address: full_address,
              detailed_address: detailed_full_address,
              lonlat: render_lonlat(target.lonlat_geojson),
              distance: distance_label(target),
              geo_salt: false,
              custom_fields: custom_fields,
              date_begin: timestamp(target.date_begin),
              date_end: timestamp(target.date_end),
              created_at: target.created_at.to_i,
              updated_at: target.updated_at.try(:to_i)
            )
    end

    attr_reader :target, :current_user

    def render_lonlat(lonlat)
      JSON.parse(lonlat)
    end

    def timestamp(value)
      value.try(:to_i)
    end

    def full_address
      [target.city, target.district, target.street, target.house, target.apartment].compact.join(' ')
    end

    def detailed_full_address
      {
        city: target.city,
        district: target.district,
        street: target.street,
        house: target.house,
        apartment: target.apartment
      }
    end

    def non_personal_address
      non_personal_address = [target.city, target.district, target.street]
      non_personal_address.push(target.house) if target.apartment.present?
      non_personal_address.compact.join(' ')
    end

    def detailed_non_personal_address
      {
        city: target.city,
        district: target.district,
        street: target.street,
        house: target.apartment.blank? && target.house || nil,
        apartment: nil
      }
    end

    def distance_label(target)
      distance = target.try(:distance)
      return '' unless distance

      if distance > 2000
        "#{(distance / 1000).round} км"
      elsif distance > 1000
        "#{(distance / 1000).round(1)} км"
      elsif distance > 100
        "#{(distance.to_i / 100).round * 100} м"
      else
        "#{(distance.to_i / 10).round * 10} м"
      end
    end

    def custom_fields
      custom_values = target.custom_values
      custom_fields = target.custom_fields
      custom_fields.map do |custom_field|
        {
          name: custom_field.name,
          value: custom_values.find { |cv| cv.custom_field == custom_field }.try(:value),
          type: custom_field.data_type
        }
      end
    end
  end
end

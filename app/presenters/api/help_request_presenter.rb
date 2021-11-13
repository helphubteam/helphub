# frozen_string_literal: true

module Api
  class HelpRequestPresenter
    FULL_ATTRIBUTES = %i[id title phone state comment number person mediated meds_preciption_required volunteer_id period recurring].freeze
    NON_PERSONAL_ATTRIBUTES = %i[id title state comment number mediated meds_preciption_required volunteer_id period recurring].freeze

    def initialize(target, current_user)
      @target = target
      @current_user = current_user
    end

    def call
      return full_data if (target.volunteer == current_user) && target.assigned?

      non_personal_data
    end

    private

    # rubocop:disable Metrics/AbcSize
    def non_personal_data
      target.attributes.slice(*NON_PERSONAL_ATTRIBUTES.map(&:to_s))
            .merge(
              address: non_personal_address, detailed_address: detailed_non_personal_address,
              lonlat: render_lonlat(target.lonlat_with_salt_geojson), distance: distance_label,
              geo_salt: true, custom_fields: custom_fields(public_only: true), phone: non_personal_phone,
              date_begin: timestamp(target.date_begin), date_end: timestamp(target.date_end),
              created_at: timestamp(target.created_at), updated_at: timestamp(target.updated_at),
              activated_days_ago: activated_days_ago(target.activated_at),
              creator_phone: target.creator.try(:phone)
            )
    end

    def full_data
      target.attributes.slice(*FULL_ATTRIBUTES.map(&:to_s))
            .merge(
              address: full_address, detailed_address: detailed_full_address,
              lonlat: render_lonlat(target.lonlat_geojson), distance: distance_label,
              geo_salt: false, custom_fields: custom_fields, activated_days_ago: activated_days_ago(target.activated_at),
              date_begin: timestamp(target.date_begin), date_end: timestamp(target.date_end),
              created_at: target.created_at.to_i, updated_at: target.updated_at.try(:to_i),
              creator_phone: target.creator.try(:phone)
            )
    end
    # rubocop:enable Metrics/AbcSize

    attr_reader :target, :current_user

    def render_lonlat(lonlat)
      result = JSON.parse(lonlat)
      result['coordinates'][0], result['coordinates'][1] = result['coordinates'][1], result['coordinates'][0]
      result
    end

    def timestamp(value)
      value.try(:to_i)
    end

    def full_address
      [target.city, target.district, target.street, target.house, target.apartment].compact.join(' ')
    end

    def detailed_full_address
      {
        city: target.city, district: target.district, street: target.street, house: target.house, apartment: target.apartment
      }
    end

    def non_personal_address
      non_personal_address = [target.city, target.district, target.street]
      non_personal_address.push(target.house) if target.apartment.present?
      non_personal_address.compact.join(' ')
    end

    def non_personal_phone
      phone = target.phone
      masked_phone = phone.gsub(/\d/, '*')
      return masked_phone if phone.size < 5

      left, right = phone.size > 7 ? [2, 2] : [1, 1]
      "#{phone[0..left]}#{masked_phone[(left + 1)..(-right - 1)]}#{phone[-right..-1]}"
    end

    def detailed_non_personal_address
      { city: target.city, district: target.district, street: target.street, house: target.apartment.blank? && target.house || nil, apartment: nil }
    end

    def distance_label
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

    def custom_fields(public_only: false)
      custom_values = target.custom_values
      custom_fields = target.custom_fields
      custom_fields.map do |custom_field|
        if public_only && !custom_field.public_field
          nil
        # We skip address custom field as we use address fields instead
        elsif custom_field.data_type == 'address'
          nil
        else
          { 
            name: custom_field.name,
            value: build_custom_value(custom_field, custom_values),
            type: build_custom_type(custom_field.data_type)
          }
        end
      end.compact
    end

    def build_custom_value(custom_field, custom_values)
      value = custom_values.find { |cv| cv.custom_field == custom_field }.try(:value)
      case custom_field.data_type
      when 'checkbox'
        build_checkbox_value(value)
      when 'phone'
        build_phone_value(value)
      else
        value
      end
    end

    def build_custom_type(type)
      return 'string' if type == 'phone'
      
      type
    end

    def build_checkbox_value(value)
      value == '1'
    end

    def build_phone_value(value)
      return '' if value.blank? || JSON.parse(value).blank?
      JSON.parse(value)["phone"] || ''
    end

    def activated_days_ago(value)
      value.nil? ? 0 : (Date.today - value).try(:to_i)
    end
  end
end

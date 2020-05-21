# frozen_string_literal: true

class HelpRequestPresenter
  AVAILABLE_ATTRIBUTES = [
    :id,
    :phone,
    :address,
    :state,
    :comment,
    :person,
    :mediated,
    :meds_preciption_required,
    :volunteer_id
  ].freeze

  def initialize(target, current_user)
    @target = target
    @current_user = current_user
  end

  def call
    target.
      attributes.
      slice(*AVAILABLE_ATTRIBUTES.map(&:to_s)).
      merge(
        lonlat: lonlat_geojson,
        geo_salt: geo_salt?,
        created_at: target.created_at.to_i,
        updated_at: target.updated_at.try(:to_i)
      )
  end

  private

  attr_reader :target, :current_user

  def geo_salt?
    target.active? || target.volunteer != current_user
  end

  def lonlat_geojson
    lonlat = geo_salt? ? target.lonlat_with_salt_geojson : target.lonlat_geojson
    JSON.parse(lonlat)
  end
end

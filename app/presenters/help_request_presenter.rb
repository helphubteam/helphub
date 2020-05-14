# frozen_string_literal: true

class HelpRequestPresenter < BasePresenter
  def call
    target.attributes.merge({
      lonlat: JSON.parse(target.lonlat_geojson),
      created_at: target.created_at.to_i,
      created_at: target.created_at.to_i
    })
  end
end
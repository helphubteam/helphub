require 'active_support/concern'

module HasGeoSalt
  extend ActiveSupport::Concern

  included do
    GEO_SALT_SIZE = 0.002

    before_save :apply_salt!

    private

    def apply_salt!
      self.lonlat_with_salt_geojson = lonlat_with_geo_salt(lonlat_geojson)
    end

    def lonlat_with_geo_salt(source_point)
      return nil unless source_point

      point = JSON.parse(source_point)
      point['coordinates'].map! do |value|
        value + GEO_SALT_SIZE * rand(-50..49) / 100.0
      end
      point.to_json
    end
  end
end

require 'rgeo/geo_json'

module GeojsonAccessor
  def self.included(base)
    base.class_exec do
      extend ClassMethods
    end
  end

  module ClassMethods
    def geojson_accessor(*fields)
      fields.each do |field|
        geojson_field = "#{field}_geojson"

        define_method "#{geojson_field}=" do |geojson|
          rgeo_obj = RGeo::GeoJSON.decode geojson, json_parser: :json
          send "#{field}=", rgeo_obj
        end

        define_method geojson_field do
          geometry = send field
          return nil if geometry.nil?

          hash = RGeo::GeoJSON.encode geometry
          hash.to_json
        end
      end
    end
  end
end

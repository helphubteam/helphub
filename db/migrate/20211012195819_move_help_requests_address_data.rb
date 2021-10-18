class HelpRequestModel < ActiveRecord::Base
  self.table_name = 'help_requests'
  include GeojsonAccessor
  geojson_accessor :lonlat, :lonlat_with_salt

  include HasGeoSalt


  has_many :custom_values, foreign_key: "help_request_id", class_name: 'CustomValueModel'
end

class HelpRequestKindModel < ActiveRecord::Base
  self.table_name = 'help_request_kinds'
  
  has_many :custom_fields, foreign_key: "help_request_kind_id", class_name: 'CustomFieldModel'
  has_many :help_requests, foreign_key: "help_request_kind_id", class_name: 'HelpRequestModel'
end

class CustomFieldModel < ActiveRecord::Base
  self.table_name = 'custom_fields'
end

class CustomValueModel < ActiveRecord::Base
  self.table_name = 'custom_values'
end


class MoveHelpRequestsAddressData < ActiveRecord::Migration[6.1]
  def up
    HelpRequestKindModel.all.each do |kind|
      address_field = kind.custom_fields.create!(
        name: "Адрес",
        data_type: "address"
      )

      kind.help_requests.each do |help_request|
        address_value = {
          "city" => help_request.city,
          "street" => help_request.street,
          "house" => help_request.house,
          "coordinates" => JSON.parse(help_request.lonlat_geojson),
          "apartment" => help_request.apartment,
          "district" => help_request.district
        }

        CustomValueModel.create!(
          help_request_id: help_request.id,
          value: address_value.to_json,
          custom_field_id: address_field.id
        )
      end
    end
  end

  def down
  end
end

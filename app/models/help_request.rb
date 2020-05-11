class HelpRequest < ApplicationRecord
  include GeojsonAccessor
  
  geojson_accessor :lonlat

end

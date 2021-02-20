class SwapCoordinates < ActiveRecord::Migration[6.0]
  def up
    execute '
      update help_requests
      set 
        lonlat = st_makepoint(st_y(lonlat::geometry), st_x(lonlat::geometry)),
        lonlat_with_salt = st_makepoint(st_y(lonlat_with_salt::geometry), st_x(lonlat_with_salt::geometry));'
    
  end

  def down
    execute '
      update help_requests
      set 
        lonlat = st_makepoint(st_y(lonlat::geometry), st_x(lonlat::geometry)),
        lonlat_with_salt = st_makepoint(st_y(lonlat_with_salt::geometry), st_x(lonlat_with_salt::geometry));'
  end
end

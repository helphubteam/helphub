class AddLonlatWithSaltToHelpRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :lonlat_with_salt, :st_point, geographic: true
  end
end

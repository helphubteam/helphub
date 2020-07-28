class AddArchiveToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :archive, :boolean, default: false
  end
end

class AddTestFlagToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :test, :boolean, default: false
  end
end

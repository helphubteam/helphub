class AddConfigToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :config, :jsonb, default: {}
  end
end

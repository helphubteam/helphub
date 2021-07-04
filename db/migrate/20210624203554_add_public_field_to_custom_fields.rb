class AddPublicFieldToCustomFields < ActiveRecord::Migration[6.1]
  def change
    add_column :custom_fields, :public_field, :boolean, default: false
  end
end

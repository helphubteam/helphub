class CreateCustomValues < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_values do |t|
      t.text :value
      t.references :help_request, null: false
      t.references :custom_field, null: false
      t.timestamps
    end
  end
end

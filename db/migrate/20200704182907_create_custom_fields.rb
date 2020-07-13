class CreateCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_fields do |t|
      t.references :help_request_kind, null: false
      t.string :name, null: false
      t.string :data_type, null: false, default: 'string'
      t.hstore :info
      t.timestamps
    end
  end
end

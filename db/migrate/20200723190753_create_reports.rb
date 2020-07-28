class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.references :organization, null: false
      t.string :name
      t.hstore :condition
      t.string :document
      t.integer :state, default: 0, null: false
      t.timestamps
    end
  end
end

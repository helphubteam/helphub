class CreateHelpRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :help_requests do |t|
      t.st_point :lonlat, geographic: true, null: false
      t.string :phone
      t.text :address
      t.integer :state, default: 0, null: false
      t.text :comment
      t.string :person
      t.boolean :mediated, default: false, null: false
      t.boolean :meds_preciption_required
      t.timestamps
    end
  end
end

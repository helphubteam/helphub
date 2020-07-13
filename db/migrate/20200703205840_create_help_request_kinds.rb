class CreateHelpRequestKinds < ActiveRecord::Migration[6.0]
  def change
    create_table :help_request_kinds do |t|
      t.references :organization, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end

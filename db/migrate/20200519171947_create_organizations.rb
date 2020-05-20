class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :title, null: false
      t.string :country
      t.string :city
      t.string :site

      t.timestamps
    end
  end
end

class CreateStories < ActiveRecord::Migration[6.0]
  def change
    create_table :stories do |t|
      t.text :name, null: false, comment: 'Story name'
      t.timestamps
    end

    add_index :stories, :name, unique: true
  end
end

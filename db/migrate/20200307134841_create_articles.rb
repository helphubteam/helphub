# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.integer :kind, default: 0, null: false, comment: 'Type of article'
      t.text :name, null: false, comment: 'Article name'
      t.text :content, null: false, comment: 'Article text'
      t.timestamps
    end

    add_index :articles, :name
    add_index :articles, :kind
  end
end

# frozen_string_literal: true

class CreateArticlesStories < ActiveRecord::Migration[6.0]
  def change
    create_table :articles_stories do |t|
      t.integer :article_id, null: false, comment: 'Article ID'
      t.integer :story_id, null: false, comment: 'Story ID'
    end
  end
end

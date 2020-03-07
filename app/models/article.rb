# frozen_string_literal: true

class Article < ApplicationRecord
  validates :name, :content, :kind, presence: true

  enum kind: { post: 0, blog: 1, facebook: 2, tweet: 3 }

  has_and_belongs_to_many :stories
end

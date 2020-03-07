class Article < ApplicationRecord
  validates :name, :content, :kind, presence: true

  enum kind: { post: 0, blog: 1, facebook: 2, tweet: 3 }
end

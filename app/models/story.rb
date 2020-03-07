class Story < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :articles
end

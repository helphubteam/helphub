class Story < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  
end

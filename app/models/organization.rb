class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :help_requests, dependent: :restrict_with_error

  validates :title, uniqueness: true, presence: true
  validates :country, presence: true
end

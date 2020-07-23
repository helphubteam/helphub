class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :help_requests, dependent: :restrict_with_error
  has_many :help_request_kinds, dependent: :destroy

  validates :title, uniqueness: true, presence: true
  validates :country, presence: true

  def default_help_request_kind
    help_request_kinds.find_by(default: true)
  end
end

class HelpRequestKind < ApplicationRecord
  belongs_to :organization
  has_many :help_requests

  validates :organization, :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

end

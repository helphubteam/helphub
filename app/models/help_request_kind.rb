class HelpRequestKind < ApplicationRecord
  belongs_to :organization
  has_many :help_requests
  has_many :custom_fields
  accepts_nested_attributes_for :custom_fields, reject_if: :all_blank, allow_destroy: true

  validates :organization, :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }
end

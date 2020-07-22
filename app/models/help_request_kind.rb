class HelpRequestKind < ApplicationRecord
  belongs_to :organization
  has_many :help_requests
  has_many :custom_fields, dependent: :destroy
  accepts_nested_attributes_for :custom_fields, reject_if: :all_blank, allow_destroy: true

  validates :organization, :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

  after_save :normalize_defaults

  private

  def normalize_defaults
    organization.help_request_kinds.where.not(id: id).update_all default: false if default
  end
end

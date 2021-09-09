# == Schema Information
#
# Table name: help_request_kinds
#
#  id              :bigint           not null, primary key
#  default         :boolean          default(FALSE), not null
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_help_request_kinds_on_organization_id  (organization_id)
#
class HelpRequestKind < ApplicationRecord
  belongs_to :organization
  has_many :help_requests, dependent: :restrict_with_exception
  has_many :custom_fields, -> { reorder('custom_fields.id') }, dependent: :destroy
  accepts_nested_attributes_for :custom_fields, reject_if: :all_blank, allow_destroy: true

  validates :organization, :name, presence: true
  validates :name, uniqueness: { scope: :organization_id }

  after_save :normalize_defaults

  before_create :check_first_help_request_kind

  private

  def normalize_defaults
    organization.help_request_kinds.where.not(id: id).update_all default: false if default
  end

  def check_first_help_request_kind
    self.default = true if organization.help_request_kinds.blank?
  end
end

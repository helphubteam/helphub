class Organization < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :help_requests, dependent: :restrict_with_error
  has_many :help_request_kinds, dependent: :destroy
  has_many :reports, dependent: :destroy

  include HasConfig

  CONFIG_FIELDS = [
    {
      name: :notify_if_new,
      value: false,
      input: 'boolean'
    }
  ].freeze

  has_config *CONFIG_FIELDS

  validates :title, uniqueness: true, presence: true
  validates :country, presence: true

  scope :active, -> { where(archive: 'false') }

  def default_help_request_kind
    help_request_kinds.find_by(default: true)
  end
end

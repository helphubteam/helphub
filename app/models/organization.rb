# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  archive    :boolean          default(FALSE)
#  city       :string
#  config     :jsonb
#  country    :string
#  site       :string
#  test       :boolean          default(FALSE)
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
      type: :boolean
    },
    {
      name: :volunteers_can_join,
      value: true,
      type: :boolean
    }
  ].freeze

  setup_config(*CONFIG_FIELDS)

  validates :title, uniqueness: true, presence: true
  validates :country, presence: true

  scope :active, -> { where(archive: 'false') }

  def default_help_request_kind
    help_request_kinds.find_by(default: true)
  end
end

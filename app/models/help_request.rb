# == Schema Information
#
# Table name: help_requests
#
#  id                       :bigint           not null, primary key
#  activated_at             :date
#  apartment                :string
#  city                     :string
#  comment                  :text
#  date_begin               :datetime
#  date_end                 :datetime
#  district                 :string
#  house                    :string
#  lonlat                   :geography        not null, point, 4326
#  lonlat_with_salt         :geography        point, 4326
#  mediated                 :boolean          default(FALSE), not null
#  meds_preciption_required :boolean
#  number                   :string
#  period                   :integer
#  person                   :string
#  phone                    :string
#  recurring                :boolean
#  schedule_set_at          :date
#  score                    :integer          default(1), not null
#  state                    :integer          default("active"), not null
#  street                   :string
#  title                    :string(140)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  creator_id               :integer
#  help_request_kind_id     :integer
#  organization_id          :bigint
#  volunteer_id             :integer
#
# Indexes
#
#  index_help_requests_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class HelpRequest < ApplicationRecord
  include GeojsonAccessor
  geojson_accessor :lonlat, :lonlat_with_salt

  include HasGeoSalt

  belongs_to :volunteer, class_name: 'User', optional: true
  belongs_to :organization
  belongs_to :help_request_kind, optional: true
  belongs_to :creator, class_name: 'User'

  has_many :logs, -> { reorder('created_at DESC') }, class_name: 'HelpRequestLog'
  has_many :custom_fields, -> { reorder('custom_fields.id') }, through: :help_request_kind

  has_many :custom_values, -> { reorder('custom_values.custom_field_id').preload(:custom_field) }
  accepts_nested_attributes_for :custom_values, reject_if: :all_blank, allow_destroy: false

  paginates_per 20

  validates :number, presence: true, uniqueness: { scope: :organization_id }
  validates :lonlat, :comment, :city, :street, :house, presence: true
  validates :period, numericality: { allow_blank: true, greater_than: 0 }
  validates :score, inclusion: 1..5
  validates :title, length: { maximum: 140 }

  before_validation :fill_default_number

  before_create :fill_activated_at
  before_update :update_activated_at

  enum state: { active: 0, assigned: 1, submitted: 2, blocked: 3 } do
    event :assign do
      transition active: :assigned
    end

    event :submit do
      transition assigned: :submitted
    end

    event :refuse do
      before do
        self.volunteer = nil
      end

      transition assigned: :active
    end

    event :activate do
      transition blocked: :active
    end

    event :block do
      transition all - [:blocked] => :blocked
    end
  end

  scope :active, -> { where(state: :active) }
  scope :assigned, -> { where(state: :assigned) }
  scope :submitted, -> { where(state: :submitted) }
  scope :recurring, lambda {
    where.not(state: :blocked)
         .where.not(schedule_set_at: nil)
         .where.not(period: nil)
  }

  def author
    logs.where(kind: :created).first.try(:user)
  end

  def recurring_in
    return nil if blocked? || schedule_set_at.nil? || period.nil?

    period - (Time.zone.now.to_date - schedule_set_at).to_i
  end

  private

  def fill_default_number
    self.number ||= (organization.help_requests.count + 1).to_s if organization
  end

  def update_activated_at
    return unless state_changed?
    return self.activated_at = nil if state_change[1] != 'active'

    self.activated_at = Date.today
  end

  def fill_activated_at
    self.activated_at = Date.today if active?
  end
end

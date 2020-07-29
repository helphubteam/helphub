class HelpRequest < ApplicationRecord
  include GeojsonAccessor
  geojson_accessor :lonlat, :lonlat_with_salt

  include HasGeoSalt

  belongs_to :volunteer, class_name: 'User', optional: true
  belongs_to :organization
  belongs_to :help_request_kind, optional: true

  has_many :logs, -> { reorder('created_at DESC') }, class_name: 'HelpRequestLog'
  has_many :custom_fields, through: :help_request_kind

  has_many :custom_values, -> { preload(:custom_field) }
  accepts_nested_attributes_for :custom_values, reject_if: :all_blank, allow_destroy: false

  paginates_per 20

  validates :number, presence: true, uniqueness: { scope: :organization_id }
  validates :lonlat, :comment, :phone, :person, :city, :street, :house, presence: true
  validates :period, numericality: { allow_blank: true, greater_than: 0 }
  validates :score, inclusion: 1..5

  before_validation :fill_default_number

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
  scope :recurring, lambda {
    where.not(state: :blocked)
         .where.not(schedule_set_at: nil)
         .where.not(period: nil)
  }

  def author
    logs.where(kind: :created).first.try(:user)
  end

  private

  def fill_default_number
    self.number ||= (organization.help_requests.count + 1).to_s if organization
  end
end

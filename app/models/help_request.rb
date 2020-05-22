class HelpRequest < ApplicationRecord
  include GeojsonAccessor
  geojson_accessor :lonlat, :lonlat_with_salt

  include HasGeoSalt

  belongs_to :volunteer, class_name: 'User', optional: true
  belongs_to :organization

  validates :number, presence: true, uniqueness: {scope: :organization_id}

  after_initialize :fill_default_number

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
  
  private

  def fill_default_number
    self.number ||= "#{HelpRequest.maximum(:id) + 1}"
  end
end

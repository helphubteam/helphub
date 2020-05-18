class HelpRequest < ApplicationRecord
  include GeojsonAccessor

  geojson_accessor :lonlat

  belongs_to :volunteer, class_name: 'User', optional: true

  enum state: {active: 0, assigned: 1, submitted: 2, blocked: 3} do
    event :assign do
      transition :active => :assigned
    end

    event :submit do
      transition :assigned => :submitted
    end

    event :refuse do
      before do
        self.volunteer = nil
      end

      transition :assigned => :active
    end

    event :activate do
      transition :blocked => :active
    end

    event :block do
      transition all - [:blocked] => :blocked
    end
  end

  scope :active, -> { where(state: :active) }
  scope :assigned, -> { where(state: :assigned) }
end

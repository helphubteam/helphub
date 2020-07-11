class CustomField < ApplicationRecord
  DATA_TYPES = %w[string text].freeze

  belongs_to :help_request_kind

  validates :name, presence: true, uniqueness: { scope: :help_request_kind_id }
  validates :data_type, presence: true, inclusion: { in: DATA_TYPES }

  has_many :custom_values, dependent: :destroy
end

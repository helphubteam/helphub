class CustomValue < ApplicationRecord
  # help_request custom_fields nested attributes doesn't work with this validation
  # so that's why we use optional flag here
  belongs_to :help_request, optional: true

  belongs_to :custom_field

  validates :help_request, presence: true, unless: :new_record?

  has_rich_text :content
end

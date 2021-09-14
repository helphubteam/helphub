# == Schema Information
#
# Table name: custom_values
#
#  id              :bigint           not null, primary key
#  value           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  custom_field_id :bigint           not null
#  help_request_id :bigint           not null
#
# Indexes
#
#  index_custom_values_on_custom_field_id  (custom_field_id)
#  index_custom_values_on_help_request_id  (help_request_id)
#
class CustomValue < ApplicationRecord
  # help_request custom_fields nested attributes doesn't work with this validation
  # so that's why we use optional flag here
  belongs_to :help_request, optional: true

  belongs_to :custom_field

  validates :help_request, presence: true, unless: :new_record?
  validates :custom_field_id, uniqueness: { scope: :help_request_id }

  has_rich_text :content
end

# == Schema Information
#
# Table name: custom_fields
#
#  id                   :bigint           not null, primary key
#  data_type            :string           default("string"), not null
#  info                 :hstore
#  name                 :string           not null
#  public_field         :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  help_request_kind_id :bigint           not null
#
# Indexes
#
#  index_custom_fields_on_help_request_kind_id  (help_request_kind_id)
#
class CustomField < ApplicationRecord
  DATA_TYPES = %w[string textarea date checkbox phone address].freeze

  belongs_to :help_request_kind

  validates :name, presence: true, uniqueness: { scope: :help_request_kind_id }
  validates :data_type, presence: true, inclusion: { in: DATA_TYPES }

  has_many :custom_values, dependent: :restrict_with_exception

  def label
    public_field ? "#{name}<br/>(публичное поле)" : name
  end
end

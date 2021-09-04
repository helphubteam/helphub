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
FactoryBot.define do
  factory :custom_field do
    name { 'test-field' }
    data_type { 'string' }
    public_field { true }
    help_request_kind
  end
end

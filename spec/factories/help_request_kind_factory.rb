# == Schema Information
#
# Table name: help_request_kinds
#
#  id              :bigint           not null, primary key
#  default         :boolean          default(FALSE), not null
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_help_request_kinds_on_organization_id  (organization_id)
#
FactoryBot.define do
  factory :help_request_kind do
    name { 'Help Request Kind Testing' }
  end
end

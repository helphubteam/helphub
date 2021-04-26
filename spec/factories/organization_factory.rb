# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  archive    :boolean          default(FALSE)
#  city       :string
#  config     :jsonb
#  country    :string
#  site       :string
#  test       :boolean          default(FALSE)
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'faker'

FactoryBot.define do
  factory :organization do
    title { Faker::Name.name }
    country { 'Russia' }
  end
end

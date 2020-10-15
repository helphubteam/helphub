require 'faker'

FactoryBot.define do
  factory :organization do
    title { Faker::Name.name }
    country { 'Russia' }
  end
end

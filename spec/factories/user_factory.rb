# This will guess the User class
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '123qwe123qwe!' }
    sex { 0 }
    confirmed_at { Time.zone.now }
    status { :active }

    trait :admin do
      role { 'admin' }
    end

    trait :volunteer do
      role { 'volunteer' }
      organization
    end

    trait :moderator do
      role { 'moderator' }
      organization
    end
  end
end

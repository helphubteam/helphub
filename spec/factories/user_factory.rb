# This will guess the User class
FactoryBot.define do
  factory :user do
    email { 'test@email.local' }
    password { '123qwe123qwe!' }

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

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  app_version            :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  device_platform        :string
#  device_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invited_by_type        :string
#  name                   :string
#  old_role               :integer          default(0), not null
#  phone                  :string
#  policy_confirmed       :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles                  :hstore
#  score                  :integer          default(0), not null
#  sex                    :integer
#  status                 :integer          default("active")
#  surname                :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :integer
#  organization_id        :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '123qwe123qwe!' }
    sex { 0 }
    phone { Faker::PhoneNumber.phone_number }
    name { Faker::Name.name.split(' ').first }
    surname { Faker::Name.name.split(' ').last }
    confirmed_at { Time.zone.now }
    status { :active }
    policy_confirmed { true }
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

    trait :content_manager do
      role { 'content_manager' }
      organization
    end
  end
end

# == Schema Information
#
# Table name: help_requests
#
#  id                       :bigint           not null, primary key
#  activated_at             :date
#  apartment                :string
#  city                     :string
#  comment                  :text
#  date_begin               :datetime
#  date_end                 :datetime
#  district                 :string
#  house                    :string
#  lonlat                   :geography        not null, point, 4326
#  lonlat_with_salt         :geography        point, 4326
#  mediated                 :boolean          default(FALSE), not null
#  meds_preciption_required :boolean
#  number                   :string
#  period                   :integer
#  person                   :string
#  phone                    :string
#  recurring                :boolean
#  schedule_set_at          :date
#  score                    :integer          default(1), not null
#  state                    :integer          default("active"), not null
#  street                   :string
#  title                    :string(140)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  creator_id               :integer
#  help_request_kind_id     :integer
#  organization_id          :bigint
#  volunteer_id             :integer
#
# Indexes
#
#  index_help_requests_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
FactoryBot.define do
  factory :help_request do
    lonlat_geojson { '{"type":"Point","coordinates":[37.54852294921875,55.77502825125135]}' }
    phone { '123123123' }
    city { 'Moscow' }
    district { 'Center' }
    street { 'Test Street' }
    house { '12' }
    apartment { '1' }
    comment { 'test comment' }
    person { 'test person' }
    state { 'active' }
    organization
    creator { create :user, :moderator }

    trait :assigned do
      state { 'assigned' }
      volunteer { create :user, :volunteer }
    end

    trait :submitted do
      state { 'submitted' }
      volunteer { create :user, :volunteer }
    end
  end
end

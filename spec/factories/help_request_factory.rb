# This will guess the User class
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
    score { 5 }
    organization

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

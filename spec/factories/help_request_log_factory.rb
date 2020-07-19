# This will guess the User class
FactoryBot.define do
  factory :help_request_log do
    user
    help_request
    kind { :created }
  end
end

require 'rails_helper'

RSpec.shared_context 'jwt authenticated' do
  let(:default_headers) { jwt_authenticated_header(user) }
end

RSpec.configure do |rspec|
  rspec.include_context 'jwt authenticated', include_shared: true
end

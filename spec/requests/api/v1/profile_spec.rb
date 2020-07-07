require 'rails_helper'

RSpec.describe 'Api::V1::Profile', type: :request do
  include_context 'jwt authenticated'

  let(:user) { create :user, :volunteer, organization: organization }
  let(:organization) { create :organization }

  let(:profile_response) do
    {
      'created_at' => user.created_at.to_i,
      'name' => user.name,
      'surname' => user.surname,
      'phone' => user.phone,
      'email' => user.email,
      'id' => user.id,
      'organization' => organization.title,
      'role' => 'volunteer',
      'type' => 'user',
      'updated_at' => user.updated_at.to_i
    }
  end

  describe 'GET /api/v1/profile' do
    it 'returns profile data' do
      get api_v1_profile_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(profile_response)
    end
  end
end

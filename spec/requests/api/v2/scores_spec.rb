require 'rails_helper'

RSpec.describe 'Api::V2::Scores', type: :request do
  include_context 'jwt authenticated'

  let!(:user100) { create :user, :volunteer, organization: organization, score: 100 }
  let!(:user) { create :user, :volunteer, organization: organization, score: 0 }
  let!(:user50) { create :user, :volunteer, organization: organization, score: 50 }
  let!(:user10) { create :user, :volunteer, organization: organization, score: 10 }

  let(:organization) { create :organization }

  let(:scores_response) do
    [
      { 'id' => user100.id, 'score' => 100, 'email' => user100.email, 'name' => user100.name, 'surname' => user100.surname },
      { 'id' => user50.id, 'score' => 50, 'email' => user50.email, 'name' => user50.name, 'surname' => user50.surname },
      { 'id' => user10.id, 'score' => 10, 'email' => user10.email, 'name' => user10.name, 'surname' => user10.surname },
      { 'id' => user.id, 'score' => 0, 'email' => user.email, 'name' => user.name, 'surname' => user.surname }
    ]
  end

  describe 'GET /api/v2/scores' do
    it 'returns profile data' do
      get api_v2_scores_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq(scores_response)
    end
  end
end

require 'rails_helper'

RSpec.describe 'Api::V1::HelpRequests', type: :request do
  include_context 'jwt authenticated'

  describe 'when old token from wrong user role' do
    let(:user) { create :user, :admin, organization: organization, score: 3 }

    describe 'GET /api/v1/help_requests' do
      it "can't find the user" do
        get api_v1_help_requests_path
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to eq({'errors' => [{'message' => 'Пользователь не найден'}]})
      end
    end
  end
  
  let(:user) { create :user, :volunteer, organization: organization, score: 3 }
  let(:organization) { create :organization }

  describe 'GET /api/v1/help_requests' do
    it 'returns empty array' do
      get api_v1_help_requests_path
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe 'POST /api/v1/help_requests/:id/assign' do
    let!(:help_request) { create :help_request, organization: organization }

    it 'assigns HelpRequest record' do
      expect(help_request.volunteer).to be_nil
      expect(help_request.state).to eq('active')
      post(assign_api_v1_help_request_path(help_request))
      expect(help_request.reload.volunteer).to eq(user)
      expect(help_request.state).to eq('assigned')
    end
  end

  describe 'POST /api/v1/help_requests/:id/refuse' do
    let!(:help_request) { create :help_request, :assigned, volunteer: user, organization: organization }

    it 'refuses HelpRequest record' do
      expect(help_request.volunteer).to eq(user)
      expect(help_request.state).to eq('assigned')
      post(refuse_api_v1_help_request_path(help_request))
      expect(help_request.reload.volunteer).to be_nil
      expect(help_request.state).to eq('active')
    end
  end

  describe 'POST /api/v1/help_requests/:id/submit' do
    let!(:help_request) { create :help_request, :assigned, volunteer: user, organization: organization, score: 4 }
    let(:score_result_after_submit) { user.score + help_request.score }

    it 'submits HelpRequest record' do
      expect(help_request.volunteer).to eq(user)
      expect(help_request.state).to eq('assigned')
      post(submit_api_v1_help_request_path(help_request))
      expect(help_request.reload.volunteer).to eq(user)
      expect(help_request.state).to eq('submitted')
      expect(help_request.reload.volunteer.score).to eq(score_result_after_submit)
    end
  end
end

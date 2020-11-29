require 'rails_helper'

RSpec.describe 'Admin::HelpRequests', type: :request do
  let(:user) { create :user, :moderator, organization: organization }
  let(:organization) { create :organization }

  before do
    sign_in user
  end

  describe 'GET /admin/help_requests/new' do
    it 'returns success status' do
      get new_admin_help_request_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /admin/help_requests' do
    it 'returns success status' do
      get admin_help_requests_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /admin/help_requests' do
    let(:valid_create_params) do
      {
        help_request: FactoryBot.attributes_for(:help_request)
      }
    end

    it 'creates HelpRequest record' do
      expect { post(admin_help_requests_path, params: valid_create_params) }.to change { HelpRequest.count }.by(1)
      expect(response).to redirect_to(admin_help_requests_path)
    end

    let!(:help_request) { HelpRequest.new(FactoryBot.attributes_for(:help_request)) }

    it 'added activated_at field' do
      help_request.run_callbacks(:create)
      expect(help_request.state).to eq('active')
      expect(help_request.activated_at).to_not eq(nil)
      help_request.state = :blocked
      help_request.run_callbacks(:update)
      expect(help_request.activated_at).to eq(nil)
      help_request.state = :active
      help_request.run_callbacks(:create)
      expect(help_request.activated_at).to_not eq(nil)
    end
  end

  describe 'PUT /admin/help_requests/:id' do
    let!(:help_request) do
      create(:help_request, :active, organization: organization, phone: old_phone)
    end
    let(:old_phone) { '0001' }
    let(:new_phone) { '9911' }

    let(:valid_update_params) do
      {
        help_request: help_request.attributes.merge({
                                                      phone: new_phone
                                                    })
      }
    end

    it 'updates HelpRequest record' do
      expect { put(admin_help_request_path(help_request), params: valid_update_params) }
        .to change { help_request.reload.phone }
        .from(old_phone)
        .to(new_phone)
      expect(response).to redirect_to(admin_help_requests_path)
    end
  end

  describe 'DELETE /admin/help_requests/:id' do
    let!(:help_request) do
      create(:help_request, :active, organization: organization)
    end

    it "doesn't work" do
      expect do
        delete admin_help_request_path(help_request)
      end.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET /admin/help_requests/:id/edit' do
    let!(:help_request) do
      create(:help_request, :active, organization: organization)
    end

    it 'returns HelpRequest record edit page' do
      get edit_admin_help_request_path(help_request)
      expect(response).to have_http_status(200)
    end
  end

  context 'with admin user' do
    let(:user) { create :user, :admin }

    describe 'GET /admin/help_requests' do
      xit 'returns access denied' do
        get admin_help_requests_path
        expect(response).to have_http_status(200)
      end
    end
  end
end

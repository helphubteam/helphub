require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let(:user) { create :user, :admin }

  before do
    sign_in user
  end

  describe 'GET /admin/users' do
    it 'returns success status' do
      get admin_users_path
      expect(response).to have_http_status(200)
    end
  end
end

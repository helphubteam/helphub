require 'rails_helper'

RSpec.describe 'Admin::HelpRequestKinds', type: :request do
  let(:user) { create :user, :moderator, organization: organization }
  let(:organization) { create :organization }

  before do
    sign_in user
  end

  describe 'GET /admin/help_request_kinds/new' do
    it 'returns success status' do
      get new_admin_help_request_kind_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /admin/help_request_kinds' do
    it 'returns success status' do
      get admin_help_request_kinds_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /admin/help_request_kinds' do
    let(:valid_create_params) do
      { help_request_kind: FactoryBot.attributes_for(:help_request_kind) }
    end

    it 'creates HelpRequest record' do
      expect { post(admin_help_request_kinds_path, params: valid_create_params) }.to change { HelpRequestKind.count }.by(1)
      expect(response).to redirect_to(edit_admin_help_request_kind_path(HelpRequestKind.last))
    end
  end

  describe 'PUT /admin/help_request_kinds/:id' do
    let!(:help_request_kind) do
      create(:help_request_kind, organization: organization, name: old_name)
    end
    let(:old_name) { 'old name' }
    let(:new_name) { 'new name' }

    let(:valid_update_params) do
      { help_request_kind: help_request_kind.attributes.merge({ name: new_name }) }
    end

    it 'updates HelpRequestKind record' do
      expect { put(admin_help_request_kind_path(help_request_kind), params: valid_update_params) }
        .to change { help_request_kind.reload.name }
        .from(old_name)
        .to(new_name)
      expect(response).to redirect_to(admin_help_request_kinds_path)
    end
  end

  describe 'DELETE /admin/help_request_kinds/:id' do
    let!(:help_request_kind) do
      create(:help_request_kind, organization: organization)
    end

    it 'removes HelpRequestKind record' do
      expect { delete admin_help_request_kind_path(help_request_kind) }.to change { HelpRequestKind.count }.from(1).to(0)
      expect(response).to redirect_to(admin_help_request_kinds_path)
    end
  end

  describe 'GET /admin/help_request_kinds/:id/edit' do
    let!(:help_request_kind) do
      create(:help_request_kind, organization: organization)
    end

    it 'returns HelpRequest record edit page' do
      get edit_admin_help_request_kind_path(help_request_kind)
      expect(response).to have_http_status(200)
    end
  end
end

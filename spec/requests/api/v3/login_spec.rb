require 'rails_helper'

RSpec.describe 'Api::V3::Login', type: :request do

  let(:old_app_version) { '1.0.1' }
  let(:new_app_version) { '1.0.2' }
  let(:email) { 'email@email.email' }
  let(:organization) { create :organization }
  let!(:user) { create :user, :volunteer, organization: organization, email: email, password: password, app_version: old_app_version }
  let(:password) { 'testpassword!' }

  describe 'POST /api/v3/login' do
    context 'when password is correct' do
      
      it 'signs in volunteer successfully' do
        post api_v3_login_path, params: { email: email, password: password, app_version: new_app_version }
        expect(response).to have_http_status(200)
        expect(user.reload.app_version).to eq(new_app_version)
      end
    end

    context 'when user is not volunteer' do
      let!(:user) { create :user, :admin, email: email, password: password, app_version: old_app_version }

      it 'responds unathorized error' do
        post api_v3_login_path, params: { email: email, password: password, app_version: new_app_version }
        expect(response).to have_http_status(403)
        expect(user.reload.app_version).to eq(old_app_version)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Неверные логин или пароль' }] })
      end
    end

    context 'when user from archived organization' do
      let(:organization) { create :organization, archive: true }

      it 'responds unathorized error' do
        post api_v3_login_path, params: { email: email, password: password, app_version: new_app_version }
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Неверные логин или пароль' }] })
        expect(user.reload.app_version).to eq(old_app_version)
      end
    end

    context 'when password is wrong' do
      let(:wrong_password) { 'wrongpassword!' }

      it 'responds unathorized error' do
        post api_v3_login_path, params: { email: email, password: wrong_password, app_version: new_app_version }
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Неверные логин или пароль' }] })
        expect(user.reload.app_version).to eq(old_app_version)
      end
    end
  end

  describe 'POST /api/v3/refresh_token' do
    context 'when not authroized' do
      it 'responds unathorized error' do
        post api_v3_refresh_token_path, params: { app_version: new_app_version }
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Ключ не найден, необходима авторизация' }] })
        expect(user.reload.app_version).to eq(old_app_version)
      end
    end

    context 'when authorized' do
      include_context 'jwt authenticated'

      it 'responds a new token' do
        post api_v3_refresh_token_path, params: { app_version: new_app_version }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to include('token', 'expiration_date', 'email')
        expect(user.reload.app_version).to eq(new_app_version)
      end
    end
  end
end

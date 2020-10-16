require 'rails_helper'

RSpec.describe 'Api::V1::Login', type: :request do
  describe 'POST /api/v1/login' do
    context 'when password is correct' do
      let(:email) { 'email@email.email' }
      let(:password) { 'testpassword!' }
      let!(:user) { create :user, :volunteer, email: email, password: password }

      it 'signs in volunteer successfully' do
        post api_v1_login_path, params: { email: email, password: password }
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not volunteer' do
      let(:email) { 'email@email.email' }
      let(:password) { 'testpassword!' }
      let!(:user) { create :user, :admin, email: email, password: password }

      it 'responds unathorized error' do
        post api_v1_login_path, params: { email: email, password: password }
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Неверные логин или пароль' }] })
      end
    end

    context 'when user from archived organization' do
      let(:email) { 'email@email.email' }
      let(:password) { 'testpassword!' }
      let(:organization) { create :organization, archive: true }
      let!(:user) { create :user, :volunteer, organization: organization, email: email, password: password }

      it 'responds unathorized error' do
        post api_v1_login_path, params: { email: email, password: password }
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Неверные логин или пароль' }] })
      end
    end

    context 'when password is wrong' do
      let(:email) { 'email@email.email' }
      let(:password) { 'testpassword!' }
      let(:wrong_password) { 'wrongpassword!' }
      let!(:user) { create :user, :volunteer, email: email, password: password }

      it 'responds unathorized error' do
        post api_v1_login_path, params: { email: email, password: wrong_password }
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Неверные логин или пароль' }] })
      end
    end
  end

  describe 'POST /api/v1/refresh_token' do
    context 'when not authroized' do
      it 'responds unathorized error' do
        post api_v1_refresh_token_path
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'message' => 'Ключ не найден, необходима авторизация' }] })
      end
    end

    context 'when authorized' do
      include_context 'jwt authenticated'

      let(:user) { create :user, :volunteer, organization: organization }
      let(:organization) { create :organization }

      it 'responds a new token' do
        post api_v1_refresh_token_path
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to include('token', 'expiration_date', 'email')
      end
    end
  end
end

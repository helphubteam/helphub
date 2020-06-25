require 'rails_helper'

RSpec.describe "Api::V1::Login", type: :request do
  describe "POST /api/v1/login" do

    context 'when password is correct' do
      let(:email){ 'email@email.email' }
      let(:password){ 'testpassword!' }
      let!(:user) { create :user, :volunteer, email: email, password: password }

      it "signs in volunteer successfully" do
        post api_v1_login_path, params: {email: email, password: password}
        expect(response).to have_http_status(200)
      end
    end

    context 'when password is wrong' do
      let(:email){ 'email@email.email' }
      let(:password){ 'testpassword!' }
      let(:wrong_password){ 'wrongpassword!' }
      let!(:user) { create :user, :volunteer, email: email, password: password }

      it "responds unathorized error" do
        post api_v1_login_path, params: {email: email, password: wrong_password}
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)).to eq({"errors"=>[{"message"=>"Неверные логин или пароль"}]})
      end
    end
  end
end

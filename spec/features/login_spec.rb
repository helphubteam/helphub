require 'rails_helper'

describe 'login form', type: :feature do
  let(:password) { '123qwe' }
  let(:wrong_password) { '123q@we' }
  let(:email) { 'someuser@email.ru' }
  let(:wrong_email) { 'somewrong@email.ru' }
  let!(:user) { create :user, :admin, email: email, password: password }
  let(:email_field) { I18n.t('simple_form.labels.defaults.email') }
  let(:password_field) { I18n.t('simple_form.labels.defaults.password') }
  let(:success_message) { I18n.t('devise.sessions.signed_in') }
  let(:error_message) { I18n.t('devise.failure.invalid') }
  let(:user_not_found_message) { I18n.t('devise.failure.user.not_found_in_database') }

  it 'signs me in' do
    visit '/users/sign_in'
    within('#new_user') do
      fill_in email_field, with: user.email
      fill_in password_field, with: password
    end
    click_button 'Войти'
    expect(page).to have_content success_message
  end

  it "doesn't pass with wrong password" do
    visit '/users/sign_in'
    within('#new_user') do
      fill_in email_field, with: user.email
      fill_in password_field, with: wrong_password
    end
    click_button 'Войти'
    expect(page).to have_content error_message
  end

  it "can't find unexisting user" do
    visit '/users/sign_in'
    within('#new_user') do
      fill_in email_field, with: wrong_email
      fill_in password_field, with: password
    end
    click_button 'Войти'
    expect(page).to have_content user_not_found_message
  end
end

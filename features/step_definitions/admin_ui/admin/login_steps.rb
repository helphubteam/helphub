When(/^I login into staging with admin creds$/) do
  visit 'https://staging.helphub.ru'
  fill_in 'user[email]', with: 'admin@covihelp.ru'
  fill_in 'user[password]', with: 'covihelp19'
  click_on 'commit'
end

Then(/^I see admin panel page$/) do
  expect(page).to have_content(I18n.t('admin.dashboard.admin.header'))
  # To debug this you can try
  # 1) Breakpoint:
  # binding.pry
  # 2) Or take screenshot:
  # page.save_screenshot('/app/test.png') 
end

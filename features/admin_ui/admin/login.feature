@admin
Feature: Login UI
  Scenario: Successful admin user login
   When I login into staging with admin creds
   Then I see admin panel page

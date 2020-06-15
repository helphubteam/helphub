# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['SMTP_USERNAME']
  layout 'mailer'
end

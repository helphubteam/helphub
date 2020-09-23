class Admin::Notifications::Ios

  APP_ID = 'com.helphub'.freeze

  def initialize(title:, body:, user:)
    @title = title
    @body = body
    @user = user
  end

  def call
    `#{curl_line}`
  end

  private

  attr_reader :title, :body, :user

  def curl_line
    "curl -v -d '#{request_body.to_json}' -H 'apns-topic:#{APP_ID}' " \
    "--http2 --cert #{sert_path}:#{sert_password} " \
    "https://api.push.apple.com/3/device/#{user.device_token}"
  end

  def sert_path
    Rails.root.join('config/Certificates.pem').to_s
  end

  def sert_password
    ENV['IOS_CERT_PASSWORD']
  end

  def request_body
    {
      aps: {
        alert: {
          title: title,
          body: body
        },
        sound: 'default'
      }
    }
  end
end
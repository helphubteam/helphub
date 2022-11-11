class IosNotificationError < StandardError
  attr_reader :device_token, :user_id

  def initialize(message, device_token, user_id)
    @device_token = device_token 
    @user_id = user_id
    super(message)
  end
end

module Notifications
  module Platforms
    class Ios < ::Notifications::Base
      APP_ID = 'com.helphub'.freeze

      def call
        result, status = Open3.capture2e(curl_line)
        unless status.to_s.ends_with?(" exit 0")
          raise IosNotificationError.new(result, user.device_token, user.id)
        end
      end

      private

      def curl_line
        "curl -v -k -d '#{request_body.to_json}' -H 'apns-topic:#{APP_ID}' " \
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
  end
end

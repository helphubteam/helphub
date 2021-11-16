module Notifications
  module Platforms
    class Android < ::Notifications::Base
      def call
        secret_key = ENV['FCM_SECRET_KEY']
        fcm = FCM.new(secret_key)

        registration_ids = [user.device_token]
        options = {
          notification: {
            title: title,
            body: body,
            sound: 'default',
            data: data
          }
        }
        fcm.send(registration_ids, options)
      end
    end
  end
end

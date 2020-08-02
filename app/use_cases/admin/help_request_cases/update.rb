module Admin
  module HelpRequestCases
    class Update < Base
      def call
        old_volunteer = help_request.volunteer
        if help_request.update(permitted_params)
          handle_blocking!
          handle_volunteer_manual_assign!(old_volunteer)
          invoke_notification!
          return true
        end

        false
      end

      private

      def disallow_push_notifications?
        volunteer = help_request.volunteer
        !volunteer || !volunteer.device_token || !volunteer.android_device?
      end

      def invoke_notification!
        secret_key = ENV['FCM_SECRET_KEY']
        return if !secret_key || disallow_push_notifications?

        fcm = FCM.new(secret_key)

        registration_ids = [help_request.volunteer.device_token]
        options = {
          notification: {
            title: "Просьба №#{help_request.number} обновлена модератором",
            body: ''
          }
        }
        fcm.send(registration_ids, options)
      end
    end
  end
end

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

      def invoke_notification!
        volunteer = help_request.volunteer
        secret_key = ENV['FCM_SECRET_KEY']
        return if !volunteer || !volunteer.device_token ||
                  !secret_key || !volunteer.android_device?

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

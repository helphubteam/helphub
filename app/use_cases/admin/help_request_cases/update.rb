module Admin
  module HelpRequestCases
    class Update < Base
      def call
        old_volunteer = help_request.volunteer
        if help_request.update(permitted_params)
          handle_blocking!
          handle_volunteer_manual_assign!(old_volunteer)
          invoke_notification! if help_request.volunteer
          return true
        end

        false
      end

      private

      def invoke_notification!
        Notifications::PushNotification.new(
          user: help_request.volunteer,
          title: notification_title,
          body: ''
        ).call
      end
        
      def notification_title
        "Просьба №#{help_request.number} обновлена модератором"
      end
    end
  end
end

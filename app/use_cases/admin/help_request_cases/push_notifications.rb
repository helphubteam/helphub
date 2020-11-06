module Admin
  module HelpRequestCases
    module PushNotifications
      def notify_on_update!(help_request, user)
        notify_user!(user, notification_title_on_update(help_request))
      end

      def notify_on_assign!(help_request, user)
        notify_user!(user, notification_title_on_assign(help_request))
      end

      def notify_on_unassign!(help_request, user)
        notify_user!(user, notification_title_on_unassign(help_request))
      end

      def notify_user!(user, message)
        Notifications::PushNotification.new(
          user: user,
          title: message,
          body: ''
        ).call
      end

      def notification_title_on_update(help_request)
        title = "Координатор внес изменения в просьбу №#{help_request.number}"
        title += " (#{help_request.title})" if help_request.title.present?
        title
      end

      def notification_title_on_assign(help_request)
        message = "Координатор закрепил за вами просьбу №#{help_request.number}"
        message += " (#{help_request.title})" if help_request.title.present?
        message
      end

      def notification_title_on_unassign(help_request)
        message = "Координатор снял вас с просьбы №#{help_request.number}"
        message += " (#{help_request.title})" if help_request.title.present?
        message
      end
    end
  end
end

module Admin
  module HelpRequestCases
    module PushNotifications
      def notify_on_update!(help_request, volunteer, moderator)
        notify_user!(volunteer, notification_title_on_update(help_request, moderator))
      end

      def notify_on_assign!(help_request, volunteer, moderator)
        notify_user!(volunteer, notification_title_on_assign(help_request, moderator))
      end

      def notify_on_unassign!(help_request, volunteer, moderator)
        notify_user!(volunteer, notification_title_on_unassign(help_request, moderator))
      end

      def notify_user!(user, message_data)
        Notifications::PushNotification.new(
          user: user,
          title: message_data[:title],
          body: message_data[:body],
          data: message_data[:data] || {}
        ).call
      end

      def notification_title_on_update(help_request, moderator)
        body = "Координатор внес изменения в просьбу №#{help_request.number}"
        body += " (#{help_request.title})" if help_request.title.present?
        {
          title: user_full_name(moderator),
          body: body,
          data: {
            type: 'help_request:updated',
            id: help_request.id.to_s
          }
        }
      end

      def notification_title_on_assign(help_request, moderator)
        body = "Координатор назначил на вас просьбу №#{help_request.number}"
        body += " (#{help_request.title})" if help_request.title.present?
        {
          title: user_full_name(moderator),
          body: body,
          data: {
            type: 'help_request:assigned',
            id: help_request.id.to_s
          }
        }
      end

      def notification_title_on_unassign(help_request, moderator)
        body = "Координатор снял вас с просьбы №#{help_request.number}"
        body += " (#{help_request.title})" if help_request.title.present?
        {
          title: user_full_name(moderator),
          body: body,
          data: {
            type: 'help_request:unassigned',
            id: help_request.id.to_s
          }
        }
      end

      def user_full_name(user)
        result = user.name.blank? ? user.email : user.name
        result += " #{user.surname}" if user.surname.present?
        result
      end
    end
  end
end

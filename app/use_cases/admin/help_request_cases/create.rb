module Admin
  module HelpRequestCases
    class Create < Base
      def call
        if help_request.update(permitted_params)
          write_moderator_log(:created)
          handle_blocking!
          handle_volunteer_assignments!(nil)
          notify_volunteers_on_creation
          return true
        end

        false
      end

      private

      def notify_volunteers_on_creation
        if current_user.organization.notify_if_new?
          notify_volunteers(I18n.t('notifications.help_request.create'))
        end
      end
    end
  end
end

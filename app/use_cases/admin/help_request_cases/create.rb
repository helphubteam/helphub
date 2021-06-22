module Admin
  module HelpRequestCases
    class Create < Base
      def call
        if help_request.update(
          permitted_params.merge(
            creator_id: current_user.id
          )
        )
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
        notify_volunteers(I18n.t('notifications.help_request.create')) if current_user.organization.notify_if_new
      end
    end
  end
end

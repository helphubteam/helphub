module Admin
  module HelpRequestCases
    class Update < Base
      def call
        old_volunteer = help_request.volunteer
        if help_request.update(permitted_params)
          handle_blocking!
          handle_volunteer_assignments!(old_volunteer)
          notify_on_update!(help_request, help_request.volunteer, current_user) if old_volunteer && help_request.volunteer == old_volunteer
          return true
        end

        false
      end
    end
  end
end

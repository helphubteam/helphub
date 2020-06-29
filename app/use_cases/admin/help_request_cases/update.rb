module Admin
  module HelpRequestCases
    class Update < Base
      def call
        old_volunteer = help_request.volunteer
        if help_request.update(permitted_params)
          handle_blocking!
          handle_volunteer_manual_assign!(old_volunteer)
          return true
        end

        false
      end
    end
  end
end

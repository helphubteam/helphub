module Admin
  module HelpRequestCases
    class Create < Base
      def call
        if help_request.update(permitted_params)
          write_moderator_log(:created)
          handle_volunteer_assignments!(nil)
          handle_blocking!
          return true
        end

        false
      end
    end
  end
end

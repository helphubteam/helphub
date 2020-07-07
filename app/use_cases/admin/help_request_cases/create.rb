module Admin
  module HelpRequestCases
    class Create < Base
      def call
        if help_request.update(permitted_params)
          write_moderator_log(:created)
          handle_volunteer_manual_assign!(nil)
          handle_blocking!
          handle_kind_change!
          return true
        end

        false
      end
    end
  end
end

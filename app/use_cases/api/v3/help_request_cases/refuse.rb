module Api
  module V3
    module HelpRequestCases
      class Refuse < Base
        def call
          raise_error(:only_user_organization) unless help_request.organization == volunteer.organization
          raise_error(:unassigned) unless help_request.assigned?
          raise_error(:not_own) if volunteer != help_request.volunteer
          help_request.refuse!
          write_log(:refused)
        rescue UseCaseError => e
          error_response(e.message)
        else
          success_response
        end
      end
    end
  end
end

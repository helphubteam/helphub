module Api
  module V1
    module HelpRequestCases
      class Submit < Base
        def call
          raise_error(:only_user_organization) unless help_request.organization == volunteer.organization
          raise_error(:submitted_already) if help_request.submitted?
          raise_error(:unassigned) unless help_request.assigned?
          raise_error(:not_own) if volunteer != help_request.volunteer
          help_request.submit!
          write_log(:submitted)
        rescue UseCaseError => e
          error_response(e.message)
        else
          success_response
        end
      end
    end
  end
end

module HelpRequestCases
  class Submit < HelpRequestCases::Base
    def call
      begin
        unless help_request.organization == volunteer.organization
          raise_error(:only_user_organization)
        end
        raise_error(:submitted_already) if help_request.submitted?
        raise_error(:unassigned) unless help_request.assigned?
        if volunteer != help_request.volunteer
          raise_error(:not_own)
        end
        help_request.submit!
        write_log(:submitted)
      rescue HelpRequestCases::UseCaseError => e
        error_response(e.message)
      else
        success_response
      end
    end
  end
end

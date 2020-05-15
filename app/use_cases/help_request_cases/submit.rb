module HelpRequestCases
  class Submit < HelpRequestCases::Base
    def call
      begin
        raise_error(:submitted_already) if help_request.submitted?
        raise_error(:unassigned) unless help_request.assigned?
        if volunteer != help_request.volunteer
          raise_error(:not_own)
        end
        help_request.submit!
      rescue HelpRequestCases::UseCaseError => e
        error_response(e.message)
      else
        success_response
      end
    end
  end
end
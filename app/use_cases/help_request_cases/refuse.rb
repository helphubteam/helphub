module HelpRequestCases
  class Refuse < HelpRequestCases::Base
    def call
      begin
        raise_error(:unassigned) unless help_request.assigned?
        if volunteer != help_request.volunteer
          raise_error(:not_own)
        end
        help_request.refuse!
      rescue HelpRequestCases::UseCaseError => e
        error_response(e.message)
      else
        success_response
      end
    end
  end
end
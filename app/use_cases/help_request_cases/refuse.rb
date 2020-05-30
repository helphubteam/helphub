module HelpRequestCases
  class Refuse < HelpRequestCases::Base
    def call
      begin
        unless help_request.organization == volunteer.organization
          raise_error(:only_user_organization)
        end
        raise_error(:unassigned) unless help_request.assigned?
        if volunteer != help_request.volunteer
          raise_error(:not_own)
        end
        help_request.refuse!
        write_log(:refused)
      rescue HelpRequestCases::UseCaseError => e
        error_response(e.message)
      else
        success_response
      end
    end
  end
end

module Api
  module V3
    module HelpRequestCases
      class Assign < Base
        def call
          raise_error(:only_user_organization) unless @help_request.organization == volunteer.organization
          raise_error(:assigned_already) if @help_request.assigned? && @help_request.volunteer == volunteer
          raise_error(:unactive) unless @help_request.active?
          raise_error(:volunteer_role_only) unless volunteer.volunteer?
          @help_request.volunteer = volunteer
          @help_request.assign!
          write_log(:assigned)
        rescue HelpRequestCases::UseCaseError => e
          error_response(e.message)
        else
          success_response
        end
      end
    end
  end
end

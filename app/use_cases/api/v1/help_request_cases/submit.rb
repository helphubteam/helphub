module Api
  module V1
    module HelpRequestCases
      class Submit < Base
        def call
          only_user_organization_error
          submitted_already_error
          unassigned_error
          not_own_error
          increment_volunteer_score
          help_request.submit!
          write_log(:submitted)
        rescue UseCaseError => e
          error_response(e.message)
        else
          success_response
        end

        def only_user_organization_error
          raise_error(:only_user_organization) unless help_request.organization == volunteer.organization
        end

        def submitted_already_error
          raise_error(:submitted_already) if help_request.submitted?
        end

        def unassigned_error
          raise_error(:unassigned) unless help_request.assigned?
        end

        def not_own_error
          raise_error(:not_own) if volunteer != help_request.volunteer
        end

        def increment_volunteer_score
          volunteer.score += help_request.score
          volunteer.save
        end
      end
    end
  end
end

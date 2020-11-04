module Api
  module V1
    module HelpRequestCases
      class Submit < Base
        def call
          only_user_organization_error
          submitted_already_error
          unassigned_error
          not_own_error
          setup_recurring
          help_request.submit!
          increment_volunteer_score
          write_log(:submitted)
          nulify_volunteer
        rescue UseCaseError => e
          error_response(e.message)
        else
          success_response
        end

        def setup_recurring
          help_request.update(schedule_set_at: Time.zone.now.to_date)
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

        def nulify_volunteer
          help_request.update(volunteer_id: nil)
        end
      end
    end
  end
end

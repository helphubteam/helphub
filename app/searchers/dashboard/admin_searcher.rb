# frozen_string_literal: true

module Dashboard
  class AdminSearcher
    def initialize(user)
      @user = user
    end

    def call
      {
        full: {
          organizations_count: count(organizations_scope),
          moderators_count: count(moderators_scope),
          volunteers_count: count(volunteers_scope),
          help_requests_count: count(help_requests_scope)
        },
        week: {
          volunteers_count: count(week(volunteers_scope)),
          help_requests_count: count(week(help_requests_scope)),
          help_requests_submissions: count(help_requests_submission_scope)
        }
      }
    end

    private

    attr_reader :user, :organization

    def organizations_scope
      Organization.active.where(test: false)
    end

    def help_requests_scope
      non_technical_orgs(HelpRequest)
    end

    def moderators_scope
      non_technical_orgs(User.moderators)
    end

    def volunteers_scope
      non_technical_orgs(User.volunteers)
    end

    def help_requests_submission_scope
      HelpRequestLog
        .includes(help_request: :organization)
        .where(organizations: { test: false, archive: false })
        .where(kind: :submitted)
        .where('help_request_logs.created_at > ?', 1.week.ago)
    end

    def non_technical_orgs(scope)
      scope.includes(:organization).where(organizations: { test: false, archive: false })
    end

    def week(scope)
      scope.where("#{scope.table_name}.created_at > ?", 1.week.ago)
    end

    def count(scope)
      scope.count
    end
  end
end

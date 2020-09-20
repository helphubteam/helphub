module Admin
  class DashboardController < BaseController
    def index
      searcher = if current_user.admin?
                   Dashboard::AdminSearcher
                 elsif current_user.moderator?
                   Dashboard::ModeratorSearcher
                 else
                   raise Pundit::NotAuthorizedError
                 end
      @data = searcher.new(current_user).call
    end
  end
end

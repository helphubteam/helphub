module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!

    before_action do
      redirect_to new_user_session_path unless current_user && can_use_application?(current_user)
    end

    def current_organization
      current_user.try(:organization)
    end
  end
end

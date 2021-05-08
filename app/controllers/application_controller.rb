# frozen_string_literal: true

class ApplicationController < ActionController::Base
  PROMOTE_HELPHUB_APP_PAGE = 'http://helphub.ru/download'
  RECAPTCHA_MINIMUM_SCORE = 0.5
  
  include Pundit

  protected

  def after_sign_up_path_for(resource)
    pages_waiting_for_moderator_path(organization: resource.organization.title)
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.moderator?
      admin_help_requests_path
    else
      sign_out(resource)
      PROMOTE_HELPHUB_APP_PAGE
    end
  end

  def can_use_application?(resource)
    resource.admin? || resource.moderator?
  end

  rescue_from Pundit::NotAuthorizedError do
    sign_out current_user if current_user
    flash[:error] = 'У Вас нет прав на это действие'
    redirect_to new_user_session_path
  end
end

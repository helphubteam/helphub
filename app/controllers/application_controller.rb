# frozen_string_literal: true

class ApplicationController < ActionController::Base
  LANDING_WEBSITE_URL = 'http://helphub.ru'

  include Pundit

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_organizations_path
    elsif resource.moderator?
      admin_help_requests_path
    else
      sign_out(resource)
      LANDING_WEBSITE_URL
    end
  end

  def can_use_application?(resource)
    resource.admin? || resource.moderator?
  end
end

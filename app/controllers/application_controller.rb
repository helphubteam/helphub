# frozen_string_literal: true

class ApplicationController < ActionController::Base
  LADING_WEBSITE_URL = "http://helphub.ru"  

  include Pundit

  protected
  
  def after_sign_in_path_for(resource)
    return admin_help_requests_path if can_use_application?(resource)

    LADING_WEBSITE_URL
  end

  def can_use_application?(resource)
    resource.admin? || resource.moderator?
  end
end

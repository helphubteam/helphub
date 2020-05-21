# frozen_string_literal: true

class ApplicationController < ActionController::Base
  LADING_WEBSITE_URL = "http://helphub.ru"  

  include Pundit

  protected
  
  def after_sign_in_path_for(resource)
    return admin_help_requests_path if resource.admin?

    LADING_WEBSITE_URL
  end
end

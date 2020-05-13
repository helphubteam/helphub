# frozen_string_literal: true

class ApplicationController < ActionController::Base
  
  protected
  
  def after_sign_in_path_for(resource)
    return admin_help_requests_path if resource.admin?
    super
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  
  protected
  
  def after_sign_in_path_for(resource)
    if resource.admin?
      return admin_help_requests_path
    else
      # ToDo: render mobile link after attempt volonteer sign_in
    end
    super
  end
end

class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(_resource_name, resource)
    pages_waiting_for_moderator_path(organization: resource.organization.title)
  end
end

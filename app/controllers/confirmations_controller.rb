class ConfirmationsController < Devise::ConfirmationsController
  def show
    super
    notify_moderators!
  end

  protected

  def after_confirmation_path_for(_resource_name, resource)
    pages_waiting_for_moderator_path(organization: resource.organization.title)
  end
  
  private

  def notify_moderators!
    ::NewVolunteerNotificationWorker.perform_async(resource.id)
  end
end

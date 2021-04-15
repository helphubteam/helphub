class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    @organizations = available_organizations
    super
  end

  protected

  def available_organizations
    Organization.active.where(test: false)
  end

  def sign_up_params
    super.merge(volunteer: true, status: :on_check)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:organization_id, :name, :surname, :phone])
  end
end

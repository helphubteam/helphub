class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    @organizations = available_organizations
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    super
  end

  def create
    build_resource(sign_up_params)
    handle_personal_data_confirmation!
    @organizations = available_organizations
    @organization = resource.organization
    unless verify_recaptcha?(params[:recaptcha_token], 'register')
      flash[:error] = I18n.t('registration.errors.recaptcha')
      redirect_to action: :new
      return
    end
    super
  end

  protected

  def handle_personal_data_confirmation!
    if params[:personal_data_confirmation] != 'true'
      resource.errors.add(:personal_data_confirmation, I18n.t('registration.personal_data_confirmation_error'))
    end
  end

  def available_organizations
    Organization.active.where("test = false and (config ='{}' or config->'volunteers_can_join'->>'value' != 'false')")
  end

  def sign_up_params
    super.merge(volunteer: true, status: :pending)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:organization_id, :name, :surname, :phone, :policy_confirmed])
  end

  def verify_recaptcha?(token, recaptcha_action)
    secret_key = ENV["RECAPTCHA_SECRET_KEY"]
    uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{token}")
    response = Net::HTTP.get_response(uri)
    json = JSON.parse(response.body)
    json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
  end
  
  def after_inactive_sign_up_path_for(resource)
    pages_confirm_email_path(email: resource.email)
  end
end

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    @organizations = available_organizations
    super
  end

  def create
    @organizations = available_organizations
    print params[:recaptcha_token]
    unless verify_recaptcha?(params[:recaptcha_token], 'register')
      flash[:error] = "reCAPTCHA: ошибка авторизации. Повторите попытку позже."
      redirect_to action: :new
      return
    end
    super
  end

  protected

  def available_organizations
    Organization.active.where(test: false)
  end

  def sign_up_params
    super.merge(volunteer: true, status: :pending)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:organization_id, :name, :surname, :phone])
  end

  def verify_recaptcha?(token, recaptcha_action)
    secret_key = ENV["RECAPTCHA_SECRET_KEY"]
    uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{token}")
    response = Net::HTTP.get_response(uri)
    json = JSON.parse(response.body)
    print json
    json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
  end
end

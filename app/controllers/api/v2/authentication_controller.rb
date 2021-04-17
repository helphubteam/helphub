module Api
  module V2
    class AuthenticationController < Api::V2::BaseController
      before_action :set_user, only: :login
      skip_before_action :authorize_request, only: :login

      # POST /login
      def login
        if @user&.valid_password?(params[:password]) && @user&.account_active? && @user&.volunteer?
          unless @user.confirmed?
            return render json: error_response(I18n.t('authentication.errors.unconfirmed')), status: :forbidden
          end

          unless @user.active?
            return render json: error_response(I18n.t('authentication.errors.pending')), status: :forbidden
          end
          
          register_app_version!(@user, params[:app_version])
          render json: generate_token_data(@user), status: :ok
        else
          render json: error_response(I18n.t('authentication.errors.unauthorized')),
                 status: :forbidden
        end
      end

      # POST /refresh_token
      def refresh_token
        register_app_version!(current_api_user, params[:app_version])
        render json: generate_token_data(current_api_user), status: :ok
      end

      private

      def generate_token_data(user)
        time = Time.now + TOKEN_LIFETIME
        token = JsonWebToken.encode({ user_id: user.id, exp: time })

        {
          token: token,
          expiration_date: time.strftime('%m-%d-%Y %H:%M'),
          email: user.email
        }
      end

      def set_user
        @user = User.find_by_email(params[:email])
      end

      def register_app_version!(user, app_version)
        user.update(app_version: app_version)
      end

      def login_params
        params.permit(:email, :password)
      end

      def error_response(error_message)
        { errors: [{ message: error_message }] }
      end
    end
  end
end

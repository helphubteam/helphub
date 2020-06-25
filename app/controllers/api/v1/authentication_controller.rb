module Api
  module V1
    class AuthenticationController < Api::V1::BaseController
      before_action :set_user, only: :login
      skip_before_action :authorize_request, only: :login

      # POST /login
      def login
        if @user&.valid_password?(params[:password])
          time = Time.now + TOKEN_LIFETIME
          token = JsonWebToken.encode({ user_id: @user.id, exp: time })
          render json: { token: token,
                         expiration_date: time.strftime('%m-%d-%Y %H:%M'),
                         email: @user.email }, status: :ok
        else
          render json: error_response(I18n.t("authentication.errors.unauthorized")),
                 status: :unauthorized
        end
      end

      private

      def set_user
        @user = User.find_by_email(params[:email])
      end

      def login_params
        params.permit(:email, :password)
      end

      def error_response(error_message)
        { errors: [ { message: error_message } ] }
      end
    end
  end
end


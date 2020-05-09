module Api
  module V1
    class AuthenticationController < Api::V1::BaseController
      before_action :set_user, only: :login

      # POST /login
      def login
        if @user&.valid_password?(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + TOKEN_LIFETIME
          render json: { token: token,
                         expiration_date: time.strftime('%m-%d-%Y %H:%M'),
                         email: @user.email }, status: :ok
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      private

      def set_user
        @user = User.find_by_email(params[:email])
      end

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end


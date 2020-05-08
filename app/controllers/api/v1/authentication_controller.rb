module Api
  module V1
    class AuthenticationController < Api::V1::BaseController
      before_action :authorize_request, except: :login
      before_action :set_user, only: :login

      # POST /login
      def login
        if @user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 24.hours.to_i
          render json: { token: token,
                         exp: time.strftime('%m-%d-%Y %H:%M'),
                         username: @user.username }, status: :ok
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


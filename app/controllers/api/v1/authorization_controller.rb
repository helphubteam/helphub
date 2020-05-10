module Api
  module V1
    class AuthorizationController < Api::V1::BaseController
      def authorize_request
        @decoded = JsonWebToken.decode(http_auth_header)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render_error_message(e, :unauthorized)
      rescue JWT::DecodeError => e
        render_error_message(e, :unauthorized)
      end

      private

      def http_auth_header
        header = request.headers['Authorization']
        header&.split(' ')&.last
      end

      def render_error_message(error, status)
        render json: { errors: error.message },
               status: status
      end
    end
  end
end

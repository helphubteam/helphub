module Api
  module V1
    class AuthorizationController < Api::V1::BaseController
      def initialize(request)
        @request = request
      end

      def call
        authorize_request
      end

      private

      def authorize_request
        decoded = JsonWebToken.decode(http_auth_header)
        User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render_error_message(e, :unauthorized)
      rescue JWT::DecodeError => e
        render_error_message(e, :unauthorized)
      end

      def http_auth_header
        header = @request.headers['Authorization']
        header&.split(' ')&.last
      end

      def render_error_message(error, status)
        render json: { errors: error.message },
               status: status
      end
    end
  end
end

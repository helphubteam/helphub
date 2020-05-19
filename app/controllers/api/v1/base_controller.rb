# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :setup_headers, :authorize_request
      protect_from_forgery with: :null_session

      TOKEN_LIFETIME = 336.hours.to_i.freeze

      def authorize_request
        @current_api_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render_error_message(e, :unauthorized)
      rescue JWT::DecodeError => e
        render_error_message(e, :unauthorized)
      end

      protected

      attr_reader :current_api_user

      private

      def decoded
        JsonWebToken.decode(http_auth_header)
      end

      def http_auth_header
        header = request.headers['Authorization']
        header&.split(' ')&.last
      end

      def render_error_message(error, status)
        render json: {
          errors: [
            { message: error.message }
          ]
        },
               status: status
      end

      def setup_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end
    end
  end
end

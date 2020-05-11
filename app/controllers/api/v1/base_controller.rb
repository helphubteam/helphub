# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :setup_headers, :authorize_request
      protect_from_forgery with: :null_session

      TOKEN_LIFETIME = 336.hours.to_i.freeze

      private

      def setup_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end

      def authorize_request
        AuthorizationController.new.authorize_request
      end
    end
  end
end

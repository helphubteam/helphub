module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def show
        render json: current_user, status: :ok
      end
    end
  end
end

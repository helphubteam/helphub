module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def show
        render json: UserPresenter.new(current_user).call, status: :ok
      end
    end
  end
end

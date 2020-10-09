module Api
  module V1
    class ScoresController < Api::V1::BaseController
      def index
        render json: Api::ScoresPresenter.new(current_api_user).call, status: :ok
      end
    end
  end
end

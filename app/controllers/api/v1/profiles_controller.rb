module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def show
        render json: Api::UserPresenter.new(current_api_user).call, status: :ok
      end

      def subscribe
        current_api_user.device_token = params[:device_token]
        current_api_user.device_platform = params[:device_platform]
        render json: { subscribed: current_api_user.save }
      end

      def unsubscribe
        render json: {
          unsubscribed: current_api_user.update(
            device_token: nil, device_platform: nil
          )
        }
      end
    end
  end
end

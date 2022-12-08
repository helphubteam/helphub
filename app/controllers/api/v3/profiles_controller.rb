module Api
  module V3
    class ProfilesController < Api::V1::ProfilesController

      def remove_account
        current_api_user.hidden = true
        current_api_user.save(validate: false)
        render json: { removed: :ok}
      end
    end
  end
end

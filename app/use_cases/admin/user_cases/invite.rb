require 'securerandom'

module Admin
  module UserCases
    class Invite
      def initialize(user_params, current_user)
        @user_params = user_params
        @current_user = current_user
      end

      def call
        user = User.new(normalized_params)
        user.valid?
        return error_response(user) if user.errors.any?

        user.invite!
        success_response(user)
      end

      private

      attr_reader :current_user

      def normalized_params
        @normalized_params ||= begin
          res = @user_params.dup
          res[:role] = 'moderator' if res[:role] == 'admin' && !current_user.admin?
          res[:password] = SecureRandom.uuid
          res[:policy_confirmed] = true
          res
        end
      end

      def error_response(user)
        {
          user: user, error: true, message: 'Пользователь не создан.'
        }
      end

      def success_response(user)
        {
          user: user, message: 'Создан новый пользователь!'
        }
      end
    end
  end
end

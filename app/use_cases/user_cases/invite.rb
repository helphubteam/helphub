module UserCases
  class Invite
    def initialize(user_params)
      @user_params = user_params
    end

    def call
      user = User.new(@user_params)
      user.valid?
      user.errors.messages.except!(:password)
      return error_response(user) if user.errors.any?

      user.invite!
      success_response(user)
    end

    private

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
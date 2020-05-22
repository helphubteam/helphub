module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: %i[edit update destroy]

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      response = UserCases::Invite.new(user_params).call
      if response[:error]
        flash.now[:error] = response[:message]
        @user = response[:user]
        render :new
      else
        flash[:notice] = response[:message]
        redirect_to action: :index
      end
    end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to action: :index
        flash[:notice] = 'Пользователь изменен!'
      else
        render :edit
        flash[:error] = 'Не удалось изменить пользователя!'
      end
    end

    def destroy
      @user.destroy
      redirect_to action: :index
      flash[:notice] = 'Пользователь удален!'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :role, :organization_id)
    end
  end
end
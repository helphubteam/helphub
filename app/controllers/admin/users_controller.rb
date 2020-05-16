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
      @user = User.new(user_params)

      if @user.invite!
        redirect_to action: :index
      else
        render :new
      end
    end

    def edit; end

    def update
      @user.update(user_params)
      redirect_to action: :index
    end

    def destroy
      @user.destroy
      redirect_to action: :index
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :role)
    end
  end
end

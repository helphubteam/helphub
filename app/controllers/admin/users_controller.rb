module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: %i[edit update destroy]

    def index
      @users = policy_scope(User).page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      response = Admin::UserCases::Invite.new(user_params, current_user).call
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
      authorize @user
      if @user.update(user_params)
        redirect_to action: :index
        flash[:notice] = 'Пользователь изменен!'
      else
        render :edit
        flash[:error] = 'Не удалось изменить пользователя!'
      end
    end

    def destroy
      authorize @user
      @user.destroy
      redirect_to action: :index
      flash[:notice] = 'Пользователь удален!'
    end

    private

    def set_user
      @user = policy_scope(User).find(params[:id])
    end

    def user_params
      defaults = { organization_id: current_organization.id } if current_organization
      params.require(:user).permit(:name, :surname, :phone, :email, :role, :organization_id, :score)
            .reverse_merge(defaults)
    end
  end
end

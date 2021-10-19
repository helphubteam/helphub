module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: %i[edit update destroy approve]

    def index
      data = UsersSearcher.new(search_params).call
      @users = policy_scope(data[:paged_scope])
      @users_count = policy_scope(data[:base_scope]).count
    end

    def new
      @user = User.new organization: current_organization
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

    def edit
      authorize @user
    end

    def update
      authorize @user
      if @user.update(user_params)
        if current_user.admin? || current_user.moderator?
          redirect_to action: :index
        else
          redirect_to admin_help_requests_path
        end
        flash[:notice] = 'Пользователь изменен!'
      else
        render :edit
        flash[:error] = 'Не удалось изменить пользователя!'
      end
    end

    def approve
      authorize @user
      if @user.approve
        redirect_to action: :edit
        flash[:notice] = 'Пользователь активирован!'
        UserMailer.moderator_confirmation(
          user_id: @user.id,
          moderator_id: current_user.id,
          organization_id: @user.organization_id
        ).deliver_now
      else
        render :edit
        flash[:error] = 'Не удалось активировать пользователя!'
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
      permit_attributes = %i[name surname phone email sex organization_id score]

      user = @user || User.new(defaults)

      if policy(user).update_content_manager_role?
        permit_attributes << :content_manager
      end

      if policy(user).update_volunteer_role?
        permit_attributes << :volunteer
      end
      
      if policy(user).update_moderator_role?
        permit_attributes << :moderator
      end
      
      if policy(user).update_admin_role?
        permit_attributes << :admin
      end

      params.require(:user).permit(*permit_attributes)
            .reverse_merge(defaults)
    end

    def search_params
      params.permit(*UsersSearcher::DEFAULT_SEARCH_PARAMS.keys)
    end
  end
end

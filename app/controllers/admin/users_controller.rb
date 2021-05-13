module Admin
  class UsersController < Admin::BaseController
    before_action :set_user, only: %i[edit update destroy approve]

    def index
      data = UsersSearcher.new(search_params).call
      @users = policy_scope(data[:paged_scope])
      @users_count = policy_scope(data[:base_scope]).count
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

    def edit
      authorize @user
    end

    def update
      authorize @user
      if @user.update(user_params)
        redirect_to action: :index
        flash[:notice] = t(".controller.notice.update")
      else
        render :edit
        flash[:error] = t(".controller.error.update")
      end
    end

    def approve
      authorize @user
      if @user.approve
        redirect_to action: :edit
        flash[:notice] = t(".controller.notice.approve")
        UserMailer.moderator_confirmation(
          user_id: @user.id,
          moderator_id: current_user.id,
          organization_id: @user.organization_id
        ).deliver_now
      else
        render :edit
        flash[:error] = t(".controller.error.approve")
      end
    end

    def destroy
      authorize @user
      @user.destroy
      redirect_to action: :index
      flash[:notice] = t(".controller.notice.destroy")
    end

    private

    def set_user
      @user = policy_scope(User).find(params[:id])
    end

    def user_params
      defaults = { organization_id: current_organization.id } if current_organization
      permit_attributes = %i[name surname phone email sex organization_id score]

      if current_user.moderator? || current_user.admin?
        permit_attributes << :moderator
        permit_attributes << :volunteer
      end

      permit_attributes << :admin if current_user.admin?

      params.require(:user).permit(*permit_attributes)
            .reverse_merge(defaults)
    end

    def search_params
      params.permit(*UsersSearcher::DEFAULT_SEARCH_PARAMS.keys)
    end
  end
end

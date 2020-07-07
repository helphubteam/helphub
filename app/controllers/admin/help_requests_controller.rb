module Admin
  class HelpRequestsController < Admin::BaseController
    before_action :fill_help_request, only: %i[edit update destroy]
    before_action :fill_volunteers, only: %i[new edit]
    helper_method :sort_column, :sort_direction, :help_request_kinds

    def index
      @help_requests = policy_scope(HelpRequestsSearcher.new(search_params).call)
    end

    def edit
      flash.now[:danger] = 'Заявка находится в архиве' if @help_request.blocked?
    end

    def new
      @help_request = HelpRequest.new organization: current_organization
    end

    def update
      authorize @help_request

      if Admin::HelpRequestCases::Update.new(
        @help_request, params, current_user
      ).call
        flash[:notice] = 'Заявка изменена!'
        redirect_to action: :index
      else
        fill_volunteers
        flash.now[:error] = 'Не удалось изменить заявку!'
        render :edit
      end
    end

    def create
      @help_request = HelpRequest.new
      @help_request.organization = current_organization
      authorize @help_request

      if Admin::HelpRequestCases::Create.new(
        @help_request, params, current_user
      ).call
        flash[:notice] = 'Создана новая заявка!'
        redirect_to action: :index
      else
        fill_volunteers
        flash.now[:error] = "Заявка не создана! #{@help_request.errors.messages.inspect}"
        render :edit
      end
    end

    def destroy
      authorize @help_request
      @help_request.destroy
      redirect_to action: :index
      flash[:notice] = 'Заявка удалена!'
    end

    private

    def fill_volunteers
      @volunteers = User.volunteers.where(organization: current_organization)
    end

    def sort_column
      if HelpRequestsSearcher::SORT_COLUMN.include?(params[:column])
        params[:column]
      else
        'id'
      end
    end

    def sort_direction
      params[:direction] == 'desc' ? 'desc' : 'asc'
    end

    def help_request_kinds
      @help_request_kinds ||= begin
        current_organization.help_request_kinds.map do |kind|
          [kind.name, kind.id]
        end
      end
    end

    def fill_help_request
      @help_request = HelpRequest.find(params[:id])
      @help_request = policy_scope(HelpRequest).find(params[:id])
    end

    def search_params
      params.permit(*HelpRequestsSearcher::DEFAULT_SEARCH_PARAMS.keys.push(states: []))
    end
  end
end

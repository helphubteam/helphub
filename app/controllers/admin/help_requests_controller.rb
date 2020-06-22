module Admin
  class HelpRequestsController < Admin::BaseController
    before_action :fill_help_request, only: %i[edit update destroy]
    helper_method :sort_column, :sort_direction

    def index
      @help_requests = policy_scope(HelpRequestsSearcher.new(search_params).call)
    end

    def edit; end

    def new
      @help_request = HelpRequest.new organization: current_organization
    end

    def update
      authorize @help_request
      if @help_request.update(update_record_params)
        if params[:activate] && @help_request.blocked?
          @help_request.activate!
          write_moderator_log(:activated)
        elsif params[:block] && !@help_request.blocked?
          @help_request.block!
          write_moderator_log(:blocked)
        end
        flash[:notice] = 'Заявка изменена!'
        redirect_to action: :index
      else
        flash.now[:error] = 'Не удалось изменить заявку!'
        render :edit
      end
    end

    def create
      @help_request = HelpRequest.new
      set_recurring!
      @help_request.organization = current_organization
      authorize @help_request
      if @help_request.update(create_record_params)
        write_moderator_log(:created)
        flash[:notice] = 'Создана новая заявка!'
        redirect_to action: :index
      else
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

    def sort_column
      HelpRequestsSearcher::SORT_COLUMN
          .include?(params[:column]) ? params[:column] : 'id'
    end

    def sort_direction
      params[:direction] == 'desc' ? 'desc' : 'asc'
    end

    def set_recurring!
      if create_record_params[:recurring] == 'true'
        @help_request.schedule_set_at = Time.zone.now.to_date
      else
        @help_request.period = nil
      end
    end

    # TODO: refactor this controller
    def write_moderator_log(kind)
      @help_request.logs.create!(
        user: current_user,
        kind: kind.to_s
      )
    end

    def fill_help_request
      @help_request = HelpRequest.find(params[:id])
      @help_request = policy_scope(HelpRequest).find(params[:id])
    end

    def create_record_params
      params.require(:help_request).permit(
        :lonlat_geojson, :phone, :city, :district, :street, :house, :apartment, :state, :comment,
        :person, :mediated, :meds_preciption_required, :recurring, :period
      )
    end

    def update_record_params
      params.require(:help_request).permit(
        :lonlat_geojson, :phone, :city, :district, :street, :house, :apartment, :state, :comment,
        :person, :mediated, :meds_preciption_required, :recurring, :period
      )
    end

    def search_params
      params.permit(*HelpRequestsSearcher::DEFAULT_SEARCH_PARAMS.keys.push(states: []))
    end
  end
end

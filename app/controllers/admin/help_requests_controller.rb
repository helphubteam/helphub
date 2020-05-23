module Admin
  class HelpRequestsController < Admin::BaseController
    before_action :fill_help_request, only: %i[edit update destroy]

    def index
      @help_requests = policy_scope(HelpRequestsSearcher.new(search_params).call)
    end

    def edit; end

    def new
      @help_request = HelpRequest.new
    end

    def update
      authorize @help_request
      if @help_request.update_attributes(
        record_params
      )
        if params[:activate] && @help_request.blocked?
          @help_request.activate!
        elsif params[:block] && !@help_request.blocked?
          @help_request.block!
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
      @help_request.organization = current_organization
      authorize @help_request
      if @help_request.update_attributes(
        record_params
      )
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

    def fill_help_request
      @help_request = HelpRequest.find(params[:id])
      @help_request = policy_scope(HelpRequest).find(params[:id])
    end

    def record_params
      params.require(:help_request).permit(
        :lonlat_geojson, :phone, :city, :district, :street, :house, :apartment, :state, :comment,
        :person, :mediated, :meds_preciption_required, :number
      )
    end

    def search_params
      params.permit(*HelpRequestsSearcher::DEFAULT_SEARCH_PARAMS.keys)
    end
  end
end

module Admin
  class HelpRequestsController < Admin::BaseController
    before_action :fill_help_request, only: %i[edit update destroy]

    def index
      @help_requests = HelpRequestsSearcher.new(search_params).call
    end

    def edit; end

    def new
      @help_request = HelpRequest.new
    end

    def update
      if @help_request.update_attributes(
        record_params
      )
        redirect_to action: :index
      else
        render :edit
      end
    end

    def create
      @help_request = HelpRequest.new
      if @help_request.update_attributes(
        record_params
      )
        redirect_to action: :index
      else
        render :edit
      end
    end

    def destroy
      @help_request.destroy
      redirect_to action: :index
    end

    private

    def fill_help_request
      @help_request = HelpRequest.find(params[:id])
    end

    def record_params
      params.require(:help_request).permit(
        :lonlat_geojson, :phone, :address, :state, :comment,
        :person, :mediated, :meds_preciption_required
      )
    end

    def search_params
      params.permit(:limit, :offset)
    end
  end
end
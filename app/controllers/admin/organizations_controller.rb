module Admin
  class OrganizationsController < Admin::BaseController
    before_action :set_organization, only: %i[edit update destroy archive]

    def index
      @organizations = Organization.active
                                   .includes(:users, :help_requests)
      authorize @organizations
    end

    def new
      @organization = Organization.new
    end

    def create
      @organization = Organization.new(organization_params)
      authorize @organization

      if @organization.save
        redirect_to action: :index
        flash[:notice] = 'Создана новая организация!'
      else
        render :new
        flash[:error] = 'Организация не создана!'
      end
    end

    def edit
      authorize @organization
    end

    def update
      authorize @organization
      if @organization.update(organization_params)
        redirect_to action: :index
        flash[:notice] = 'Организация изменена!'
      else
        render :edit
        flash[:error] = 'Не удалось изменить организацию!'
      end
    end

    def archive
      authorize @organization
      @organization.archive = true
      @organization.save
      redirect_to action: :index
      flash[:notice] = 'Организация заархивирована!'
    end

    private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:title, :country, :city, :site, :test)
    end
  end
end

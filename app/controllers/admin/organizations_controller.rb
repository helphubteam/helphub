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
        flash[:notice] = t(".controller.notice.create")
      else
        render :new
        flash[:error] = t(".controller.error.create")
      end
    end

    def edit
      authorize @organization
    end

    def update
      authorize @organization
      if @organization.update(organization_params)
        redirect_to action: :index
        flash[:notice] = t(".controller.notice.update")
      else
        render :edit
        flash[:error] = t(".controller.error.update")
      end
    end

    def archive
      authorize @organization
      @organization.archive = true
      @organization.save
      redirect_to action: :index
      flash[:notice] = t(".controller.notice.arhived")
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

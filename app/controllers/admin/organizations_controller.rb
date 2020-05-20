module Admin
  class OrganizationsController < Admin::BaseController
    before_action :set_organization, only: %i[show edit update destroy]

    def index
      @organizations = Organization.all
    end

    def new
      @organization = Organization.new
    end

    def create
      @organization = Organization.new(organization_params)

      if @organization.save
        redirect_to action: :index
      else
        render :new
      end
    end

    def show
      @users = @organization.users
    end

    def edit; end

    def update
      @organization.update(organization_params)
      redirect_to action: :index
    end

    def destroy
      @organization.destroy
      redirect_to action: :index
    end

    private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:title, :country, :city, :site)
    end
  end
end

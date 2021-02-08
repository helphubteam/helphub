module Admin
  class OrganizationConfigsController < BaseController
    def show
      @organization = current_user.organization
      authorize @organization
    end

    def update
      @organization = current_user.organization
      
      @organization.assign_attributes(permitted_params)
      authorize @organization

      if @organization.save
        redirect_to action: :show
      else
        render :show
      end
    end

    private

    def permitted_params
      params.require(:organization).permit(*Organization::CONFIG_FIELDS.map { |field| field[:name].to_sym })
    end
  end
end

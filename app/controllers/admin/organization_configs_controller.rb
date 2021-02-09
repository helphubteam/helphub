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
      handle_fields(params.require(:organization)).permit(*Organization::CONFIG_FIELDS.map { |field| field[:name].to_sym })
    end

    def handle_fields(params)
      params.permit!.to_h.each_with_object(ActionController::Parameters.new) do |(key, value), result|
        result[key] = if Organization.config_field(key)[:type] == :boolean
                        value == '1'
                      else
                        value
                      end
      end
    end
  end
end

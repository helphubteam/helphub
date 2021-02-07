class Admin::OrganizationConfigsController < ApplicationController
  def show
    @organization = current_user.organization
  end

  def update
    @organization = current_user.organization
    if @organization.update(permitted_params)
      redirect_to action: :show
    else
      render :show
    end
  end
  
  private

  def permitted_params
    params.require(:organization).permit(*Organization::CONFIG_FIELDS.map{|field| field[:name].to_sym})
  end
end

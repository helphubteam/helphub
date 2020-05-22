class SessionsController < Devise::SessionsController

  def create
    super do
      unless resource.admin? || resource.moderator?
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
        respond_to_on_destroy
      end
    end
  end
end

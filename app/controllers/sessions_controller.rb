class SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: %i[new create]

  def create
    super do
      unless resource.admin? || resource.moderator? || resource.content_manager?
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
      end
    end
  end
end

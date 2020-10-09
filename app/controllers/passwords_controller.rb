class PasswordsController < Devise::PasswordsController
  def new
    self.resource = resource_class.new email: params[:email]
  end
end

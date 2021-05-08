class PagesController < ApplicationController
  before_action { flash.clear }

  def confirm_email;end

  def waiting_for_moderator;end

end

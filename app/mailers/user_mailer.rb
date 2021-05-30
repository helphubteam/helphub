# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def moderator_confirmation(user_id:, moderator_id:, organization_id:)
    @user = User.find(user_id)
    @moderator = User.find(moderator_id)
    @organization = Organization.find(organization_id)
    mail(to: @user.email, subject: "Вы добавлены в фонд #{@organization.title}")
  end
end

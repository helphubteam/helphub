class NewVolunteerNotificationWorker
  include Sidekiq::Worker

  def perform(user_id)
    volunteer = User.find(user_id)
    organization_id = volunteer.organization_id
    User.moderators.where(organization_id: organization_id).pluck(:id).each do |moderator_id|
      UserMailer.new_volunteer_confirmation(
        moderator_id: moderator_id,
        user_id: volunteer.id,
        organization_id: organization_id
      ).deliver_now
    end
  end
end

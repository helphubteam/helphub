class NewVolunteerNotificationWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_expired, lock_ttl: 1.week

  def perform(volunteer_id)
    volunteer = User.volunteers.find(volunteer_id)
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

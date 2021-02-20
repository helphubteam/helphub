class BroadcastPushNotificationWorker
  include Sidekiq::Worker

  # TODO: We will use worker for push notifications later on
  # as our heroku staging doesn't support this
  def perform(*args)
    organization_id, title, body = args
    organization = Organization.find(organization_id)
    Notifications::BroadcastPushNotification.new(
      organization: organization,
      body: body,
      title: title
    ).call
  end
end

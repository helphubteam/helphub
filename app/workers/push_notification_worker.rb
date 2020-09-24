class PushNotificationWorker
  include Sidekiq::Worker

  # TODO: We will use worker for push notifications later on
  # as our heroku staging doesn't support this
  def perform(*args)
    user_id, title, body = args
    user = User.find(user_id)
    PushNotification.new(
      user: user,
      body: body,
      title: title
    ).call
  end
end

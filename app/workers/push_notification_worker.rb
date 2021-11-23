class PushNotificationWorker
  include Sidekiq::Worker

  # TODO: We will use worker for push notifications later on
  # as our heroku staging doesn't support this
  def perform(*args)
    user_id, title, body, data = args
    user = User.find(user_id)
    Notifications::PushNotification.new(
      user: user,
      body: body,
      title: title,
      data: data
    ).call
  end
end

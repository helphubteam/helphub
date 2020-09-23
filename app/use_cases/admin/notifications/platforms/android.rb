class Admin::Notifications::Android

  def initialize(title:, body:, user:)
    @title = title
    @body = body
    @user = user
  end

  def call
    secret_key = ENV['FCM_SECRET_KEY']
    fcm = FCM.new(secret_key)

    registration_ids = [user.device_token]
    options = {
      notification: {
        title: title,
        body: ''
      }
    }
    fcm.send(registration_ids, options)
  end
end
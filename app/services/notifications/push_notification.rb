module Notifications
  class PushNotification < Base

    def call
      notification_driver = if user.android_device?
        Notifications::Platforms::Android
      elsif user.ios_device?
        Notifications::Platforms::Ios
      end

      notification_driver.new(
        user: user,
        title: title,
        body: body
      ).call if notification_driver
    end
  end
end

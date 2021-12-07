module Notifications
  class PushNotification < Base
    def call
      notification_driver = if user.android_device?
                              Notifications::Platforms::Android
                            elsif user.ios_device?
                              Notifications::Platforms::Ios
                            end

      return unless notification_driver

      notification_driver.new(
        user: user,
        title: title,
        body: body,
        data: data
      ).call
    end
  end
end

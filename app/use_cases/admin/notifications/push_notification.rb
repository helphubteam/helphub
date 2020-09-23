
class Admin::Notifications::PushNotification
  def initialize(user, title)
    @user = user
    @title = title
  end

  def call
    notification_driver = if volunteer.android_device?
      Admin::Notifications::Platform::Android
    elsif volunteer.ios_device?
      Admin::Notifications::Platform::Ios
    end

    notification_driver.new(
      user: user,
      title: title,
      body: ''
    ).call if notification_driver
  end

  private

  attr_reader :help_request, :title
end

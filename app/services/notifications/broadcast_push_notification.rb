module Notifications
  class BroadcastPushNotification

    def initialize(organization:, title:, body:)
      @organization, @title, @body = organization, title, body
    end

    def call
      organization.volunteer.each do |volunteer|
        notify_volunteer(volunteer, message_data)
      end
    end

    private

    attr_reader :organization, :title, :body

    def notify_volunteer(user, message_data)
      PushNotificationWorker.perform_later(
        user, title, body
      )
    end
  end
end

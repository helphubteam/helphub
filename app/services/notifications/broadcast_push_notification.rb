module Notifications
  class BroadcastPushNotification
    def initialize(organization:, title:, body:)
      @organization = organization
      @title = title
      @body = body
    end

    def call
      organization.users.volunteers.each do |volunteer|
        notify_volunteer(volunteer.id)
      end
    end

    private

    attr_reader :organization, :title, :body

    def notify_volunteer(user_id)
      PushNotificationWorker.perform_async(
        user_id, title, body
      )
    end
  end
end

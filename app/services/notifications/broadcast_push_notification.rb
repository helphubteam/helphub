module Notifications
  class BroadcastPushNotification
    def initialize(organization:, title:, body:, data:)
      @organization = organization
      @title = title
      @body = body
      @data = data
    end

    def call
      organization.users.volunteers.each do |volunteer|
        notify_volunteer(volunteer.id)
      end
    end

    private

    attr_reader :organization, :title, :body, :data

    def notify_volunteer(user_id)
      PushNotificationWorker.perform_async(
        user_id, title, body, data
      )
    end
  end
end

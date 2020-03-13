class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'NotificationsChannel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "NotificationsChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast(
      "NotificationsChannel",
      message: data[data]
    )
  end
end
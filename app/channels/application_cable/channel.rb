# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      stream_from "web_notifications"
    end
  end
end

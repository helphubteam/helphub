# frozen_string_literal: true

require 'active_support/concern'

module LiveUpdatable
  extend ActiveSupport::Concern

  included do
    after_commit :notify_clients

    private

    def notify_clients
      ActionCable.server.broadcast(
        'NotificationsChannel', message: 'updated'
      )
    end
  end
end

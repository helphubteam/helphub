# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect; end
  end
end

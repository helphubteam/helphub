module Notifications
  class Base
    def initialize(title:, body:, data:, user:)
      @title = title
      @body = body
      @user = user
      @data = data
    end

    def call
      raise NotImplemented
    end

    protected

    attr_reader :title, :body, :user, :data
  end
end

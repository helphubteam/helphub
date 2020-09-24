class Notifications::Base

  def initialize(title:, body:, user:)
    @title = title
    @body = body
    @user = user
  end

  def call
    raise NotImplemented
  end

  protected

  attr_reader :title, :body, :user

end
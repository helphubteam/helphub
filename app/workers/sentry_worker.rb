class SentryWorker
  include Sidekiq::Worker

  def perform(event)
    Sentry.send_event(event)
  end
end

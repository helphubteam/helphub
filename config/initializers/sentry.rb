return if ENV['SENTRY_DSN'].blank?

Sentry.init do |config|
  config.environment = ENV['RAILS_ENV']
  config.enabled_environments = %w[production staging development]
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = %i[sentry_logger active_support_logger]
  config.traces_sample_rate = 0.5
  config.send_default_pii = true
  config.traces_sampler = lambda do |_context|
    ENV['RAILS_ENV'] == 'production'
  end
  config.async = lambda { |event|
    SentryWorker.perform_async(event)
  }
end

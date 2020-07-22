require 'sidekiq-scheduler'

class RecurringHelpRequestsWorker
  include Sidekiq::Worker

  def perform(*_args)
    Recurring.call
  end
end

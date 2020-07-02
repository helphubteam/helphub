require 'sidekiq-scheduler'

class RecurringHelpRequestsWorker
  include Sidekiq::Worker

  def perform(*_args)
    recurring_help_requests = HelpRequest.recurring
    Recurring.call(recurring_help_requests)
  end
end

class Recurring < ApplicationService
  attr_accessor :recurring_help_requests
  attr_reader :date_now

  def initialize(scope)
    @recurring_help_requests = scope
    @date_now = Time.zone.now.to_date
  end

  def call
    update_recurring_help_requests
  end

  def update_recurring_help_requests
    recurring_help_requests.each do |help_request|
      if check_need_start?(help_request) && !help_request.blocked?
        help_request.update(state: :active)
        help_request.update(schedule_set_at: date_now)
        write_recurring_log(help_request, :repeated) # ToDo: add repeated kind
      end
    end
  end

  def check_need_start?(help_request)
    (date_now - help_request.schedule_set_at).to_i == help_request.period
  end

  def write_recurring_log(help_request, kind)
    help_request.logs.create!(
        user: user, # ToDo: changed user?
        kind: kind.to_s
    )
  end
end

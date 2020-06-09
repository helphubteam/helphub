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

  private

  def update_recurring_help_requests
    recurring_help_requests.each do |help_request|
      if check_need_start?(help_request)
        update_help_request(help_request)
        write_recurring_log(help_request)
      end
    end
  end

  def check_need_start?(help_request)
    (date_now - help_request.schedule_set_at).to_i == help_request.period
  end

  def update_help_request(help_request)
    help_request.update(params_to_update)
    help_request.user = nil unless help_request.active?
  end

  def write_recurring_log(help_request)
    help_request.logs.create!(
      user: help_request.author,
      kind: 'refreshed'
    )
  end

  def params_to_update
    {
        state: :active,
        schedule_set_at: date_now
    }
  end
end

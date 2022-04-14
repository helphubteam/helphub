# frozen_string_literal: true

module ApplicationHelper
  RECAPTCHA_SITE_KEY = ENV["RECAPTCHA_SITE_KEY"]

  def help_request_state_label(record)
    [
      state_badge(record), recurring_bage(record)
    ].compact.join('&nbsp')
  end

  def state_badge(record)
    content_tag(:span, class: "badge #{state_css(record.state)}") do
      I18n.t("help_request.states.#{record.state}")
    end
  end

  def yandex_map_apikey
    tag :meta, name: "yandex_map_apikey", content: ENV["YANDEX_MAP_APIKEY"]
  end

  def sentry_keys
    tag :meta, name: "sentry", content: ENV["SENTRY_DSN"]
  end

  def state_css(state)
    case state
    when 'active'
      'badge-primary'
    when 'blocked'
      'badge-danger'
    when 'assigned'
      'badge-warning'
    when 'submitted'
      'badge-success'
    end
  end

  def recurring_bage(record)
    return unless record.recurring_in

    content_tag(:span, class: "badge #{state_css(record.state)}") do
      I18n.t('help_request.recurring_in', count: record.recurring_in)
    end
  end

  def site_name
    'HelpHub'
  end

  def print_datetime(datetime)
    content_tag :span, class: 'js-print-datetime hidden' do
      datetime.try(:iso8601)
    end
  end

  def sort_link(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'

    icon = sort_direction == 'asc' ? 'glyphicon glyphicon-chevron-up' : 'glyphicon glyphicon-chevron-down'
    icon = column == sort_column ? icon : ''
    link_to "#{title} <span class='#{icon}'></span>".html_safe,
            params.merge(column: column, direction: direction).permit!
  end

  def user_label(user)
    # [user.name.present? && user.surname.present? && [user.name, user.surname] || user.email, user.phone].flatten.join(' ').squeeze(' ').strip
    fields = [user.name, user.surname].all?(&:present?) ? [user.name, user.surname] : [user.email]
    fields << user.phone if user.phone.present?
    fields.join(' ')
  end

  def report_state_label(report)
    css = case report.state
          when 'enqueued'
            'badge-primary'
          when 'errored'
            'badge-danger'
          when 'processing'
            'badge-warning'
          when 'finished'
            'badge-success'
          end
    content_tag :span, class: "badge #{css}" do
      I18n.t(".reports.state.#{report.state}")
    end
  end

  def report_document_path(report)
    "/#{report.document}"
  end

  def include_recaptcha_js
    raw %Q{
      <script src="https://www.google.com/recaptcha/api.js?render=#{RECAPTCHA_SITE_KEY}"></script>
    }
  end

  def recaptcha_execute(action)
    id = "recaptcha_token_#{SecureRandom.hex(10)}"

    raw %Q{
      <input name="recaptcha_token" type="hidden" id="#{id}"/>
      <script>
        grecaptcha.ready(function() {
          grecaptcha.execute('#{RECAPTCHA_SITE_KEY}', {action: '#{action}'}).then(function(token) {
            document.getElementById("#{id}").value = token;
          });
        });
      </script>
    }
  end
end

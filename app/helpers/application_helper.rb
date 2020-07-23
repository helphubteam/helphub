# frozen_string_literal: true

module ApplicationHelper
  def help_request_state_label(record)
    css = case record.state
          when 'active'
            'badge-primary'
          when 'blocked'
            'badge-danger'
          when 'assigned'
            'badge-warning'
          when 'submitted'
            'badge-success'
      end
    content_tag :span, class: "badge #{css}" do
      I18n.t("help_request.states.#{record.state}")
    end
  end

  def site_name
    'HelpHub'
  end

  def print_datetime(datetime)
    content_tag :span, class: 'js-print-datetime hidden' do
      datetime.to_s
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
end

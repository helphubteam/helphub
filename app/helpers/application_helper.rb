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

  def user_format_by_fields(*fields)
    user_fields = []
    fields.each do |field|
      user_fields << field
    end

    user_fields.join(' ')
  end
end

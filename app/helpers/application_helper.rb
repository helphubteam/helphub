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
end

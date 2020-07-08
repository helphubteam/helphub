# frozen_string_literal: true

module BootstrapFlashHelper
  ALERT_TYPES = %i[success info warning danger].freeze unless const_defined?(:ALERT_TYPES)

  # rubocop:disable Metrics/MethodLength
  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      tag_class = options.extract!(:class)[:class]
      tag_options = {
        class: "alert alert-#{type} #{tag_class}"
      }.merge(options)

      close_button = content_tag(
        :button,
        raw('&times;'),
        type: 'button',
        class: 'close',
        'data-dismiss' => 'alert',
        'onclick' => "document.getElementsByClassName('alert')[0].style.display='none';"
      )

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, tag_options)
        flash_messages << text if msg
      end
    end
    flash_messages = [content_tag(:div, nil, class: 'mt-2')] + flash_messages if flash_messages.any?
    flash_messages.join("\n").html_safe
  end
  # rubocop:enable Metrics/MethodLength
end

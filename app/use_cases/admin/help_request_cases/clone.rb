module Admin
  module HelpRequestCases
    class Clone
      include Rails.application.routes.url_helpers

      def initialize(help_request, current_user)
        @help_request = help_request
        @current_user = current_user
      end

      attr_reader :help_request, :current_user

      BLANK_ATTRIBUTES = %w[id created_at updated_at volunteer_id number].freeze

      def call
        help_request_clone = build_help_request_clone
        help_request_clone.save!
        build_log(help_request_clone)
        notify_volunteers_on_creation
        help_request_clone
      end

      private

      def notify_volunteers_on_creation
        notify_volunteers(
          I18n.t('notifications.help_request.create'),
          { type: 'help_request:created', id: help_request.id.to_s }
        ) if current_user.organization.notify_if_new
      end

      def notify_volunteers(message, data)
        BroadcastPushNotificationWorker.perform_async(
          current_user.organization_id, message, '', data
        )
      end

      def build_help_request_clone
        record = HelpRequest.new(
          help_request
            .attributes
            .except(*BLANK_ATTRIBUTES)
            .merge(
              'state' => 'active'
            )
        )
        record.custom_values_attributes = custom_values_attributes
        record
      end

      def custom_values_attributes
        help_request.custom_values.map { |cv| cv.attributes.slice('value', 'custom_field_id') }
      end

      def build_log(help_request_clone)
        help_request_clone.logs.create!(
          user: current_user,
          kind: :cloned,
          comment: "<a href=#{edit_admin_help_request_path(help_request)}>№#{help_request.number}(#{help_request.title})</a>"
        )
      end
    end
  end
end

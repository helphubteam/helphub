module Admin
  module HelpRequestCases
    class Clone
      include Rails.application.routes.url_helpers

      def initialize(help_request, current_user)
        @help_request = help_request
        @current_user = current_user
      end

      attr_reader :help_request, :current_user

      def call
        help_request_clone = help_request.dup
        help_request_clone.id = nil
        help_request_clone.created_at = nil
        help_request_clone.updated_at = nil
        help_request_clone.volunteer = nil
        help_request_clone.state = :active
        help_request_clone.number = nil
        help_request_clone.custom_values_attributes = help_request.custom_values.map do |cv|
          {
            value: cv.value,
            custom_field_id: cv.custom_field_id
          }
        end
        help_request_clone.save!
        build_log(help_request_clone)
        help_request_clone
      end

      private

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

module Admin
  module HelpRequestCases
    class Clone
      def initialize(help_request, current_user)
        @help_request = help_request
        @current_user = current_user
      end

      def call
        help_request_clone = @help_request.dup
        help_request_clone.id = nil
        help_request_clone.created_at = nil
        help_request_clone.updated_at = nil
        help_request_clone.volunteer = nil
        help_request_clone.state = :active
        help_request_clone
      end
    end
  end
end

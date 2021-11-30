module Admin
  module HelpRequestCases
    class Update < Base
      def call
        old_volunteer = help_request.volunteer
        prelim_handle_address!(permitted_params)
        if help_request.update(permitted_params)
          write_update_log(help_request, permitted_params)
          handle_blocking!
          handle_volunteer_assignments!(old_volunteer)
          notify_on_update!(help_request, help_request.volunteer, current_user) if old_volunteer && help_request.volunteer == old_volunteer
          return true
        end

        false
      end
    
      private

      LOG_EXCLUDE_FIELDS = [
          :created_at,
          :updated_at,
          :lonlat,
          :lonlat_with_salt,
          :volunteer_id,
          :state,
          :activated_at
      ].freeze

      def write_update_log(help_request, permitted_params)
        comment = []

        help_request.previous_changes.each do |field, (old_value, new_value)|
          next if LOG_EXCLUDE_FIELDS.include? field.to_sym
          comment << I18n.t("activerecord.attributes.help_request.#{field}") + ": #{old_value} -> #{new_value}" 
        end
        write_moderator_log(:updated, comment.join(";     ")) if comment.any?
      end
    end
  end
end

module Admin
  module HelpRequestCases
    class Base
      def initialize(help_request, params, current_user)
        @help_request = help_request
        @params = params
        @current_user = current_user
      end

      def call
        raise NotImplemented
      end

      private

      attr_reader :help_request, :params, :current_user

      def handle_volunteer_manual_assign!(old_volunteer)
        return if help_request.volunteer == old_volunteer

        if help_request.volunteer
          help_request.assign! if help_request.active?
          write_moderator_log(:manual_assign, 'Волонтер ' + help_request.volunteer.to_s)
        else
          help_request.refuse! if help_request.assigned?
          write_moderator_log(:manual_unassign, 'Волонтер ' + old_volunteer.to_s)
        end
      end

      def handle_blocking!
        if params[:activate] && help_request.blocked?
          help_request.activate!
          help_request.assign! if help_request.volunteer
          write_moderator_log(:activated)
        elsif params[:block] && !help_request.blocked?
          help_request.block!
          write_moderator_log(:blocked)
        end
      end

      def apply_recurring(result)
        if result[:recurring] == 'true'
          result[:schedule_set_at] = Time.zone.now.to_date
        else
          result[:period] = nil
        end
        result
      end

      def permitted_params
        result = params.require(:help_request).permit(
          :lonlat_geojson, :phone, :city, :district, :street,
          :house, :apartment, :state, :comment,
          :person, :mediated, :meds_preciption_required, :recurring,
          :period, :volunteer_id, :help_request_kind_id, :score, :date_begin, :date_end, :title,
          custom_values_attributes: %i[value custom_field_id id]
        )
        apply_recurring(result)
      end

      def write_moderator_log(kind, comment = nil)
        @help_request.logs.create!(
          user: current_user,
          kind: kind.to_s,
          comment: comment
        )
      end
    end
  end
end

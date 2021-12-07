module Admin
  # rubocop:disable Metrics/ClassLength
  class HelpRequestsController < Admin::BaseController
    before_action :fill_help_request, only: %i[edit update destroy custom_fields clone]
    before_action :fill_volunteers, only: %i[new edit update]
    helper_method :sort_column, :sort_direction, :help_request_kinds

    def index
      data = HelpRequestsSearcher.new(search_params).call
      @help_requests = policy_scope(data[:paged_scope])
      @users = policy_scope(current_organization.users.moderators.or(current_organization.users.content_managers))
      @help_requests_count = policy_scope(data[:base_scope]).count
    end

    def edit
      authorize @help_request
      flash.now[:danger] = 'Просьба находится в архиве' if @help_request.blocked?
    end

    def new
      @help_request = HelpRequest.new(
        organization: current_organization,
        help_request_kind: current_organization.default_help_request_kind
      )
    end

    def update
      authorize @help_request

      if Admin::HelpRequestCases::Update.new(
        @help_request, params, current_user
      ).call
        flash[:notice] = 'Просьба изменена'
        redirect_to action: :index
      else
        fill_volunteers
        fill_custom_values
        flash.now[:error] = 'Не удалось изменить просьбу'
        render :edit
      end
    end

    def create
      @help_request = HelpRequest.new
      @help_request.organization = current_organization
      authorize @help_request

      if Admin::HelpRequestCases::Create.new(
        @help_request, params, current_user
      ).call
        flash[:notice] = 'Создана новая просьба'
        redirect_to action: :index
      else
        fill_volunteers
        fill_custom_values
        flash.now[:error] = "Просьба не создана #{@help_request.errors.messages.inspect}"
        render :edit
      end
    end

    def destroy
      authorize @help_request
      @help_request.destroy
      redirect_to action: :index
      flash[:notice] = 'Просьба удалена'
    end

    # rubocop:disable Metrics/MethodLength
    def custom_fields
      help_request_kind_id = params[:help_request_kind_id]
      if help_request_kind_id.blank?
        render json: []
        return
      end

      existing_custom_values = if @help_request.nil?
                                 {}
                               else
                                 @help_request
                                   .custom_values
                                   .pluck(:custom_field_id, :id, :value)
                                   .map do |(custom_field_id, id, value)|
                                   [custom_field_id, { id: id, value: value, custom_field_id: custom_field_id }]
                                 end.to_h
                               end
      custom_fields_data = CustomField.includes(:help_request_kind)
                                      .where(help_request_kinds: { organization: current_organization })
                                      .where(help_request_kind_id: help_request_kind_id)
                                      .reorder('custom_fields.created_at')
                                      .map do |custom_field|
        existing_custom_value = existing_custom_values[custom_field.id]
        {
          id: existing_custom_value.try(:[], :id),
          value: existing_custom_value.try(:[], :value),
          custom_field_id: custom_field.id,
          name: custom_field.label,
          data_type: custom_field.data_type
        }
      end
      render json: custom_fields_data
    end
    # rubocop:enable Metrics/MethodLength

    def fill_custom_values
      return if params[:help_request].try(:[], :custom_values_attributes).nil?

      data = params[:help_request][:custom_values_attributes].permit!.to_h
      @custom_values = data.map do |id, custom_value|
        custom_field_id = custom_value[:custom_field_id]
        custom_field = CustomField.find_by_id custom_field_id
        next unless custom_field
        {
          id: nil,
          value: custom_value[:value],
          custom_field_id: custom_value[:custom_field_id],
          name: custom_field.label,
          data_type: custom_field.data_type
        }
      end.compact
    end

    def clone
      authorize @help_request

      result = Admin::HelpRequestCases::Clone.new(
        @help_request, current_user
      ).call
      flash[:notice] = 'Просьба склонирована'
      redirect_to edit_admin_help_request_path(result)
    end

    private

    def fill_volunteers
      @volunteers = User.volunteers.where(organization: current_organization)
    end

    def sort_column
      if HelpRequestsSearcher::SORT_COLUMN.include?(params[:column])
        params[:column]
      else
        'id'
      end
    end

    def sort_direction
      params[:direction] == 'desc' ? 'desc' : 'asc'
    end

    def help_request_kinds
      @help_request_kinds ||= begin
        current_organization.help_request_kinds.map do |kind|
          [kind.name, kind.id]
        end
      end
    end

    def fill_help_request
      return if params[:id].to_i.zero?

      @help_request = HelpRequest.find(params[:id])
      @help_request = policy_scope(HelpRequest).find(params[:id])
    end

    def search_params
      params.permit(*HelpRequestsSearcher::DEFAULT_SEARCH_PARAMS.keys.push(states: []).push(creator_id: []))
    end
  end
  # rubocop:enable Metrics/ClassLength
end

module Admin
  class HelpRequestKindsController < BaseController
    before_action :set_help_request_kind, only: %i[edit update destroy]

    def index
      @help_request_kinds = policy_scope(HelpRequestKind)
    end

    def new
      @help_request_kind = HelpRequestKind.new
    end

    def create
      @help_request_kind = HelpRequestKind.new(help_request_kind_params)
      @help_request_kind.organization = current_organization
      authorize @help_request_kind

      if @help_request_kind.save
        redirect_to edit_admin_help_request_kind_path(@help_request_kind)
        flash[:notice] = 'Создан новый вид просьбы'
      else
        render :new
        flash[:error] = 'Вид просьбы не создан'
      end
    end

    def edit
      authorize @help_request_kind
    end

    def update
      authorize @help_request_kind
      begin
        if @help_request_kind.update(help_request_kind_params)
          redirect_to action: :index
          flash[:notice] = 'Вид просьбы изменен'
          return
        else
          render :edit
          return
        end
      rescue ActiveRecord::DeleteRestrictionError
        flash[:error] = 'Не удалось удалить поле так как оно уже заполнено в просьбах'
        render :edit
      end
    end

    def destroy
      authorize @help_request_kind
      begin
        @help_request_kind.destroy
        flash[:notice] = 'Вид просьбы удален'
      rescue ActiveRecord::DeleteRestrictionError
        flash[:error] = 'Невозможно удалить вид просьбы когда существуют просьбы этого вида'
      ensure
        redirect_to action: :index
      end
    end

    def force_show_flash_notice?
      true
    end

    private

    def set_help_request_kind
      @help_request_kind = current_organization.help_request_kinds.find(params[:id])
    end

    def help_request_kind_params
      params.require(:help_request_kind).permit(
        :name, :default, custom_fields_attributes: %i[id name data_type public_field _destroy]
      )
    end
  end
end

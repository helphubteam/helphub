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
        redirect_to action: :index
        flash[:notice] = 'Создан новый вид просьбы'
      else
        render :new
        flash[:error] = 'Вид просьбы не создан'
      end
    end

    def edit; end

    def update
      authorize @help_request_kind
      if @help_request_kind.update(help_request_kind_params)
        redirect_to action: :index
        flash[:notice] = 'Вид просьбы изменен'
      else
        render :edit
        flash[:error] = 'Не удалось изменить вид просьбы'
      end
    end

    def destroy
      authorize @help_request_kind
      @help_request_kind.destroy
      redirect_to action: :index
      flash[:notice] = 'Вид просьбы удален'
    end

    private

    def set_help_request_kind
      @help_request_kind = current_organization.help_request_kinds.find(params[:id])
    end

    def help_request_kind_params
      params.require(:help_request_kind).permit(
        :name, custom_fields_attributes: %i[id name _destroy]
      )
    end
  end
end

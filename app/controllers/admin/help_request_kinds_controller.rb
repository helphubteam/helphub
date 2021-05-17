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
        flash[:notice] = t(".controller.notice.create")
      else
        render :new
        flash[:error] = t(".controller.error.create")
      end
    end

    def edit
      authorize @help_request_kind
    end

    def update
      authorize @help_request_kind
      if @help_request_kind.update(help_request_kind_params)
        redirect_to action: :index
        flash[:notice] = t(".controller.notice.edit")
      else
        render :edit
        flash[:error] = t(".controller.error.edit")
      end
    end

    def destroy
      authorize @help_request_kind
      @help_request_kind.destroy
      redirect_to action: :index
      flash[:notice] = t(".controller.notice.destroy")
    end

    private

    def set_help_request_kind
      @help_request_kind = current_organization.help_request_kinds.find(params[:id])
    end

    def help_request_kind_params
      params.require(:help_request_kind).permit(
        :name, :default, custom_fields_attributes: %i[id name data_type _destroy]
      )
    end
  end
end

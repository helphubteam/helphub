module Admin
  class ReportsController < BaseController

    def index
      @reports = current_organization.reports.page(params[:page]).reorder(created_at: :desc)
      @report = Report.new(organization: current_organization)

      authorize @reports
    end

    def create
      @report = Report.new(report_params)
      authorize @report

      if @report.save
        redirect_to action: :index
        flash[:notice] = 'Генерация отчета началась!'
      else
        render :idnex
        flash[:error] = 'Ошибки при создании отчета'
      end
    end

    private

    def report_params
      params.require(:report).permit(:name, :organization_id)
    end

  end
end
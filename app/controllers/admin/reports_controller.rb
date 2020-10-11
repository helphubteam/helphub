module Admin
  class ReportsController < BaseController
    def index
      @reports = current_organization.reports.page(params[:page]).reorder(created_at: :desc)
      @report = Report.new(organization: current_organization)

      authorize @reports
    end

    def create
      # @report = Report.new(report_params)
      # authorize @report

      # if @report.save
      #   GenerateReportWorker.perform_async(@report.id)
      #   redirect_to action: :index
      #   flash[:notice] = 'Генерация отчета началась!'
      # else
      #   render :idnex
      #   flash[:error] = 'Ошибки при создании отчета'
      # end

      data = ComposeReportData.call(current_organization)
      filename = "#{report_params[:name]}.csv"
      options = {
        type: 'text/csv; charset=utf-8; header=present',
        filename: filename,
        disposition: "attachment; filename=#{filename}"
      }
      send_data data, options
    end

    private

    def report_params
      params.require(:report).permit(:name, :organization_id)
    end
  end
end

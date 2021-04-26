module Admin
  class ReportsController < BaseController
    def index
      @reports = current_organization.reports.page(params[:page]).reorder(created_at: :desc)
      @report = Report.new(organization: current_organization)

      authorize @reports
    end

    def create
      logs = HelpRequestLog.includes(:help_request, :user)
                           .where(users: { organization: current_organization })
      data = ActionController::Base.new.render_to_string(
        layout: false,
        template: 'admin/reports/template.xlsx.axlsx',
        handlers: [:axlsx],
        formats: [:xlsx],
        locals: { logs: logs, current_organization: current_organization }
      )
      filename = "Отчет по заявкам #{current_organization.title}.xlsx"
      options = { filename: filename, type: Mime[:xlsx], disposition: 'inline' }
      send_data data, options
    end

    private

    def report_params
      params.require(:report).permit(:name, :organization_id)
    end
  end
end

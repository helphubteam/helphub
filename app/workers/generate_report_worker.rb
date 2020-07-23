class GenerateReportWorker
  include Sidekiq::Worker

  def perform(*args)
    report_id = args[0]
    report = Report.find(report_id)
    GenerateReport.call(report)
  end
end

class GenerateReport
  def self.call(report)
    report.process!
    begin
      document = ComposeReportDocument.call(report.organization)
      report.document = document
      report.save!
    rescue StandardError => e
      report.break!
      raise e
    end
    report.finish!
  end
end

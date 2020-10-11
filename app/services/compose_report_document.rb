require 'securerandom'
require 'csv'

class ComposeReportDocument
  def self.call(organization)
    filename = "reports/#{SecureRandom.uuid}.csv"
    data = ComposeReportData.call(organization)
    File.write(filename, data)
    filename
  end
end

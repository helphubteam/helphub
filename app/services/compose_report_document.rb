require 'securerandom'
require 'csv'

class ComposeReportDocument
  def self.call(report)
    filename = "reports/#{SecureRandom.uuid}.csv"
    CSV.open(Rails.root.join('public', filename), 'w') do |file|
      file << [
        'Номер заявки', 'Пользователь', 'Действие', 'Комментарий', 'Время изменений'
      ]
      organization = report.organization
      
      HelpRequestLog
        .includes(:help_request, :user)
        .where(users: { organization: organization })
        .find_each do |log|
          file << [
          log.help_request.number,
          log.user.email,
          I18n.t("help_request_log.kind.#{log.kind}"),
          log.comment,
          I18n.l(log.created_at, format: :short)
        ]
      end
    end
    filename
  end
end

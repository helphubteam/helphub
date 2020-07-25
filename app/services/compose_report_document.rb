require 'securerandom'
require 'csv'

class ComposeReportDocument
  def self.call(report)
    filename = "reports/#{SecureRandom.uuid}.csv"
    CSV.open(Rails.root.join('public', filename), 'w') do |file|
      file << [
        'Номер заявки', 'Пользователь', 'Email', 'Действие', 'Комментарий', 'Время изменений'
      ]
      organization = report.organization

      HelpRequestLog
        .includes(:help_request, :user)
        .where(users: { organization: organization })
        .find_each do |log|
        file << row(log)
      end
    end
    filename
  end

  def self.row(log)
    [
      log.help_request.number,
      [log.user.name, log.user.surname].join(' '),
      log.user.email,
      I18n.t("help_request_log.kind.#{log.kind}"),
      log.comment,
      "#{I18n.l(log.created_at, format: :short)} #{Time.zone}"
    ]
  end
end

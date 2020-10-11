require 'csv'

class ComposeReportData
  def self.call(organization)
    CSV.generate do |csv|
      csv << [
        'Номер заявки', 'Пользователь', 'Email', 'Действие', 'Комментарий', 'Время изменений'
      ]

      HelpRequestLog
        .includes(:help_request, :user)
        .where(users: { organization: organization })
        .find_each do |log|
        csv << row(log)
      end
    end
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

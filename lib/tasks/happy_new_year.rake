namespace :happy_new_year do
  desc 'Send send congratulations to all Helphub volunteers'
  task start: :environment do
    message_data = {
      body: 'Спасибо за ваши добрые сердца, будьте счастливы и здоровы! Мы рады быть с вами, команда HelpHub.',
      title: 'Поздравляем вас с Новым годом!'
    }
    User.where.not(device_token: nil).find_each do |user|
      notify_user(user, message_data)
    end
  end

  private

  def notify_user(user, message_data)
    Notifications::PushNotification.new(
      user: user,
      title: message_data[:title],
      body: message_data[:body]
    ).call

    puts "#{user.email}: notification sent to #{user.device_platform}"
  end
end

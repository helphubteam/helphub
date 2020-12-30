namespace :happy_new_year do
  desc 'Send send congratulations to all Helphub volunteers'
  task start: :environment do
    user_ids = User.where.not(device_token: nil).pluck(:id)
    message_data = {
      body: 'Спасибо за ваши добрые сердца, будьте счастливы и здоровы! Мы рады быть с вами, команда HelpHub.',
      title: 'Поздравляем вас с Новым годом!'
    }
    user_ids.each do |user_id|
      notify_user(user_id, message_data)
    end
  end

  private

  def notify_user(id, message_data)
    user = User.find_by_id(id)

    unless user
      puts "#{id}: user not found"
      return
    end

    unless user.device_token
      puts "#{user.email}: user has no mobile app"
      return
    end

    Notifications::PushNotification.new(
      user: user,
      title: message_data[:title],
      body: message_data[:body]
    ).call

    puts "#{user.email}: notification sent to #{user.device_platform}"
  end
end

namespace :the_last_call do
  desc 'Send send congratulations to all Helphub volunteers'
  task push_start: :environment do
    message_data = {
      body: 'TODO: add text',
      title: 'TODO: add text'
    }
    User.where.not(device_token: nil).find_each do |user|
      notify_user(user, message_data)
    end
  end

  task email_start: :environment do
    User.find_each do |user|
      deliver_email_to_user(user, message_data)
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

  def deliver_email_to_user(user)
    UserMailer.the_last_call(
      user_id: user.id
    ).deliver_now
  end
  
end

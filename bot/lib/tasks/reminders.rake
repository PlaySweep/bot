namespace :reminders do
  desc "Send Reminder to all"
  task :announcement do
    get_users_with_reminders
    menu = [
      {
        content_type: 'text',
        title: 'Select picks',
        payload: 'SELECT PICKS'
      },
      {
        content_type: 'text',
        title: 'Status',
        payload: 'STATUS'
      },
      {
        content_type: 'text',
        title: 'Handle notifications',
        payload: 'MANAGE NOTIFICATIONS'
      }
    ]
    @users.each_with_index do |user, index|
      begin
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: user["user"]["facebook_uuid"] },
          message: {
            text: "Hi everyone, I'm Emma! Welcome to the newest version of Sweep 🎉",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        puts "** Message sent for reminders to #{user["user"]['first_name']} #{user["user"]['last_name']} **"
        sleep 30 if index % 50 == 0
      rescue Facebook::Messenger::FacebookError => e
        puts "User: #{user["user"]['first_name']} #{user["user"]['last_name']} can not be reached..."
        next
      end
    end
  end
end
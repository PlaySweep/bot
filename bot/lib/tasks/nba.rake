namespace :nba do
  desc "Send Reminder to all"
  task :to_all do
    get_users
    menu = [
      {
        content_type: 'text',
        title: 'Select picks',
        payload: 'Select picks'
      },
      {
        content_type: 'text',
        title: 'Status',
        payload: 'Status'
      },
      {
        content_type: 'text',
        title: 'Manage updates',
        payload: 'Manage updates'
      }
    ]
    @users.each_with_index do |user, index|
      begin
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: user["user"]["facebook_uuid"] },
          message: {
            text: "Good morning #{user["user"]["first_name"]}, we have new sports offerings! Come check out our selection of college basketball and olympic games 🇺🇸",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        # sleep 1
        # reminder_gifs = [{id: 1531726016876435, title: "Ok, Lets ride"}]
        # media_options = {
        #   messaging_type: "UPDATE",
        #   recipient: { id: user["user"]["facebook_uuid"] },
        #   message: {
        #     attachment: {
        #       type: 'image',
        #       payload: {
        #         attachment_id: reminder_gifs.sample[:id]
        #       }
        #     },
        #     quick_replies: menu
        #   }
        # }
        # Bot.deliver(media_options, access_token: ENV['ACCESS_TOKEN'])
        puts "** Message sent for reminders to #{user["user"]['first_name']} #{user["user"]['last_name']} **"
        sleep 30 if index % 50 == 0
      rescue Facebook::Messenger::FacebookError => e
        puts "User: #{user["user"]['first_name']} #{user["user"]['last_name']} can not be reached..."
        next
      end
    end
  end
end
module Profile

  START_BUTTON = {
    get_started: {
      payload: 'START'
    }
  }

  START_GREETING = {
    greeting: [
      {
        locale: 'default',
        text: "This is a game of streaks, {{user_first_name}}!\n\nWhether it's 4 wins or 4 losses, we'll reward you with Amazon 💰\n\n100% Free. 100% Fun. Forever."
      }
    ]
  }

  SIMPLE_MENU = {
    persistent_menu: [
      {
        locale: 'default',
        composer_input_disabled: false,
        call_to_actions: [
          {
            type: 'nested',
            title: 'Actions ⚡️',
            call_to_actions: [
              {
                title: 'Select picks 👆',
                type: 'postback',
                payload: 'SELECT PICKS' 
              },
              {
                title: 'Status 🙏',
                type: 'postback',
                payload: 'STATUS' 
              },
              {
                title: 'My picks 🙌',
                type: 'postback',
                payload: 'MY PICKS' 
              },
              {
                title: 'Leaderboard & Stats 📚',
                type: 'postback',
                payload: 'STATS'
              }
            ]
          },
          {
            type: 'nested',
            title: 'Share & Friends 🎉',
            call_to_actions: [
              {
                title: 'Invite friends 💌',
                type: 'postback',
                payload: 'INVITE FRIENDS'
              },
              {
                title: 'Challenge a friend 💪',
                type: 'postback',
                payload: 'FRIENDS'
              }
            ]
          },
          {
            type: 'nested',
            title: 'Settings & Help 👻',
            call_to_actions: [
              {
                title: 'How to play 🤔',
                type: 'web_url',
                url: ENV['WEBVIEW_URL'],
                webview_height_ratio: 'full'
              },
              {
                title: 'Sweepstore 🛍',
                type: 'web_url',
                url: ENV['WEBVIEW_URL'],
                webview_height_ratio: 'full'
              },
              {
                title: 'Notifications 👋',
                type: 'postback',
                payload: 'MANAGE NOTIFICATIONS'
              }
            ]
          }
        ]
      }
    ]
  }
end

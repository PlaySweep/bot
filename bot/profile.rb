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
                title: 'Dashboard 🙌',
                type: 'postback',
                payload: 'DASHBOARD'
              },
              {
                title: 'Select Picks 👆',
                type: 'postback',
                payload: 'SELECT PICKS' 
              },
              {
                title: 'Status 🤔',
                type: 'postback',
                payload: 'STATUS' 
              },
              {
                title: 'Challenges 🤝',
                type: 'postback',
                payload: 'CHALLENGE'
              },
              {
                title: 'My Picks 🤑',
                type: 'postback',
                payload: 'MY PICKS' 
              }
            ]
          },
          {
            title: 'Invite friends 🎉',
            type: 'postback',
            payload: 'INVITE FRIENDS'
          },
          {
            type: 'nested',
            title: 'Notifications & Help 👾',
            call_to_actions: [
              {
                title: 'Notifications 👋',
                type: 'postback',
                payload: 'MANAGE NOTIFICATIONS'
              },
              # {
              #   title: 'AD TEST',
              #   type: 'postback',
              #   payload: 'SINGLE_MATCHUP FALCONS CARDINALS'
              # },
              {
                title: 'How to Play 🤷‍♀️',
                type: 'web_url',
                url: "#{ENV['WEBVIEW_URL']}/help",
                messenger_extensions: true,
                webview_height_ratio: 'full'
              }
            ]
          }
        ]
      }
    ]
  }
end

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
        text: "Welcome to Sweep {{user_first_name}}, a game of streaks 💫\n\nWhether it's 4 wins or 4 losses, I reward you with in-app prizes and Amazon cash 💰\n\n💯 percent free!"
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
              }
            ]
          },
          {
            title: 'Invite friends 🎉',
            type: 'postback',
            payload: 'INVITE FRIENDS'
          },
          {
            title: 'Notifications 👋',
            type: 'postback',
            payload: 'MANAGE NOTIFICATIONS'
          }
          # {
          #   type: 'nested',
          #   title: 'Notifications & Help 👾',
          #   call_to_actions: [
          #     {
          #       title: 'Notifications 👋',
          #       type: 'postback',
          #       payload: 'MANAGE NOTIFICATIONS'
          #     },
          #     {
          #       title: 'AD TEST',
          #       type: 'postback',
          #       payload: 'SINGLE_MATCHUP FALCONS CARDINALS'
          #     },
          #   ]
          # }
        ]
      }
    ]
  }
end

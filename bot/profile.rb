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
        text: "Welcome to Sweep {{user_first_name}}, a game of streaks 💫\n\nPick 4 straight winners and earn Sweepcoins toward an Amazon gift card 💰\n\n💯 percent free!"
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
                title: 'Make Picks 💯',
                type: 'postback',
                payload: 'SELECT PICKS' 
              },
              {
                title: 'Status 📈',
                type: 'postback',
                payload: 'STATUS' 
              },
              {
                title: 'Tournament Play 🏆',
                type: 'postback',
                payload: 'CHALLENGES'
              },
              {
                title: 'Share & Earn 🎉',
                type: 'postback',
                payload: 'INVITE FRIENDS'
              }
            ]
          },
          {
            type: 'nested',
            title: 'Sweepcoins 🤑',
            call_to_actions: [
              {
                title: 'Shop 🛍',
                type: 'postback',
                payload: 'STORE'
              },
              {
                title: 'Cash Out 💸',
                type: 'postback',
                payload: 'CASH OUT'
              }
            ]
          },
          {
            type: 'nested',
            title: 'Preferences ⭐️',
            call_to_actions: [
              {
                title: 'Notifications 💥',
                type: 'postback',
                payload: 'PREFERENCES'
              }
            ]
          }
        ]
      }
    ]
  }
end

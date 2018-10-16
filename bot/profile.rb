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
              title: 'Make Picks 💯',
              type: 'postback',
              payload: 'SELECT PICKS' 
            },
            {
              title: 'Upcoming Schedule 📅',
              type: 'postback',
              payload: 'SCHEDULE' 
            },
            {
              title: 'Invite Friends',
              type: 'postback',
              payload: 'INVITE FRIENDS'
            }
          ]
        }
      ]
    }
end

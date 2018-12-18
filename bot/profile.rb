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
        text: "Welcome to The Budweiser Sweep Nick 💫\n\nPick 3 winners and earn a chance at exclusive Knicks prizes 🏀️"
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

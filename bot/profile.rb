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
        text: "Welcome to the SWEEP {{user_first_name}}!\nTap Get Started below to start answering questions and winning exclusive prizes!"
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

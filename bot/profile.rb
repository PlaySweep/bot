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
                title: 'Make picks',
                type: 'postback',
                payload: 'SELECT PICKS' 
              },
              {
                title: 'Status',
                type: 'postback',
                payload: 'STATUS' 
              },
              {
                title: 'Challenges',
                type: 'postback',
                payload: 'CHALLENGES'
              },
              {
                title: 'Leaderboard',
                type: 'postback',
                payload: 'LEADERBOARD'
              },
              {
                title: 'Store',
                type: 'postback',
                payload: 'STORE'
              }
            ]
          },
          {
            title: 'Invite friends',
            type: 'postback',
            payload: 'INVITE FRIENDS'
          },
          {
            title: 'Notifications',
            type: 'postback',
            payload: 'MANAGE NOTIFICATIONS'
          }
        ]
      }
    ]
  }
end

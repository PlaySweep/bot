module Profile
  # Configure profile for your bot (Start Button, Greeting, Menu)

  START_BUTTON = {
    get_started: {
      payload: 'START'
    }
  }

  START_GREETING = {
    greeting: [
      {
        locale: 'default',
        text: "We're goin' streaking, {{user_first_name}}!\n\nGet 4 games in a row and win Amazon 💰\n\n100% Free. 100% Fun. Forever. "
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
            title: '🏅 Select picks',
            type: 'postback',
            payload: 'SELECT PICKS' 
          },
          {
            title: '📈 Status',
            type: 'postback',
            payload: 'STATUS' 
          },
          {
            type: 'nested',
            title: '🤖 Quick Actions',
            call_to_actions: [
              {
                title: '🎉 Share & Earn',
                type: 'postback',
                payload: 'INVITE FRIENDS'
              },
              {
                title: '💰 Sweepcoins',
                type: 'postback',
                payload: 'SWEEPCOINS'
              },
              # {
              #   title: '📚 Record',
              #   type: 'postback',
              #   payload: 'RECORD'
              # },
              {
                title: '👋 Notifications',
                type: 'postback',
                payload: 'MANAGE UPDATES'
              }
            ]
          }
        ]
      }
    ]
  }
end

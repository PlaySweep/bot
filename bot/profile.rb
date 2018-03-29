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
            type: 'nested',
            title: '⚡️ Actions',
            call_to_actions: [
              {
                title: '🙏 Status',
                type: 'postback',
                payload: 'STATUS' 
              },
              {
                title: '👆 Select picks',
                type: 'postback',
                payload: 'SELECT PICKS' 
              },
              {
                title: '🙌 My picks',
                type: 'postback',
                payload: 'MY PICKS' 
              },
              {
                title: '🎉 Share & Earn',
                type: 'postback',
                payload: 'INVITE FRIENDS'
              }
            ]
          },
          {
            type: 'nested',
            title: '📊 Dashboard',
            call_to_actions: [
              {
                title: '📚 Stats',
                type: 'postback',
                payload: 'STATS'
              },
              {
                title: '📈 Leaderboard',
                type: 'postback',
                payload: 'LEADERBOARD' 
              },
              {
                title: '👯 Friends',
                type: 'postback',
                payload: 'FRIENDS'
              },
              {
                title: '💰 Wallet',
                type: 'postback',
                payload: 'SWEEPCOINS'
              }
            ]
          },
          {
            type: 'nested',
            title: '👻 Extra',
            call_to_actions: [
              {
                title: '🛍 Sweepstore',
                type: 'postback',
                payload: 'SWEEPSTORE'
              },
              {
                title: '👋 Notifications',
                type: 'postback',
                payload: 'MANAGE UPDATES'
              },
              {
                title: '🤔 How to Play',
                type: 'postback',
                payload: 'HOW TO PLAY'
              },
            ]
          }
        ]
      }
    ]
  }
end

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
        text: "Hey {{user_first_name}}, we're Sweep 👋\n\nWe’re a sports bot to give you some upside while you watch the games.\n\nPredict 4 games in a row and win your piece of a $50 Amazon Gift Card every game day."

Check us out!"
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
            type: 'postback',
            title: 'Help',
            payload: 'HELP'
          }
        ]
      }
    ]
  }

  # SIMPLE_MENU = {
  #   persistent_menu: [
  #     {
  #       locale: 'default',
  #       composer_input_disabled: false,
  #       call_to_actions: [
  #         {
  #           type: 'nested',
  #           title: 'Actions',
  #           call_to_actions: [
  #             {
  #               title: 'Leaderboard',
  #               type: 'postback',
  #               payload: 'Leaderboard'
  #             },
  #             {
  #               title: 'Select picks',
  #               type: 'postback',
  #               payload: 'Select picks'
  #             },
  #             {
  #               title: 'Status',
  #               type: 'postback',
  #               payload: 'Status'
  #             }
  #           ]
  #         },
  #         {
  #           type: 'postback',
  #           title: 'Help',
  #           payload: 'HELP'
  #         },
  #         {
  #           type: 'postback',
  #           title: 'How To Play',
  #           payload: 'HOW TO PLAY'
  #         }
  #       ]
  #     }
  #   ]
  # }
end

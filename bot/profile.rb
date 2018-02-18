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
        text: "Hey {{user_first_name}}, we're Sweep 👋\n\nGet 4 wins in a row and win up to $50 worth of Amazon gift cards every game day!"
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
  #           type: 'postback',
  #           title: 'Invite friends',
  #           payload: 'INVITE FRIENDS'
  #         },
  #         {
  #           type: 'postback',
  #           title: 'Send feedback',
  #           payload: 'SEND FEEDBACK'
  #         },
  #         {
  #           type: 'postback',
  #           title: 'Manage updates',
  #           payload: 'MANAGE UPDATES'
  #         }
  #       ]
  #     }
  #   ]
  # }

  SIMPLE_MENU = {
    persistent_menu: [
      {
        locale: 'default',
        composer_input_disabled: false,
        call_to_actions: [
          {
            type: 'nested',
            title: '🤖 Profile',
            call_to_actions: [
              {
                title: 'Dashboard',
                type: 'web_url',
                messenger_extensions: true,
                webview_height_ratio: 'full',
                url: "#{ENV["WEBVIEW_URL"]}?id={{user_id}}&sport=nfl"
              },
              {
                title: 'Invite friends',
                type: 'postback',
                payload: 'INVITE FRIENDS'
              },
              {
                title: 'Notifications & Alerts',
                type: 'postback',
                payload: 'MANAGE UPDATES'
              }
            ]
          },
          {
            title: '🏅 Make picks',
            type: 'postback',
            payload: 'SELECT PICKS' 
          },
          {
            type: 'nested',
            title: '📈 Status',
            call_to_actions: [
              {
                title: 'Current',
                type: 'postback',
                payload: 'STATUS'
              },
              {
                title: 'Referrals',
                type: 'postback',
                payload: 'REFERRALS'
              }
            ]
          },
        ]
      }
    ]
  }
end

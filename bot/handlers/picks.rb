module Commands
  def handle_show_sports
    @api = Api.new
    @api.fetch_sports
    if @api.sports.map(&:upcase).include?(message.quick_reply)
      user.session[:game_type] = 'game'
      handle_pick
    else
      redirect(:show_sports) and stop_thread and return if !message.quick_reply
      if message.quick_reply.split(' ')[0..1].join(' ') == 'ACCEPT CHALLENGE'
        payload = message.quick_reply.split(' ')[0...-1].join(' ') unless !message.quick_reply
        id = message.quick_reply.split(' ')[-1] unless !message.quick_reply
        accept_challenge_action(id)
      elsif message.quick_reply.split(' ')[0..1].join(' ') == 'DECLINE CHALLENGE'
        payload = message.quick_reply.split(' ')[0...-1].join(' ') unless !message.quick_reply
        id = message.quick_reply.split(' ')[-1] unless !message.quick_reply
        decline_challenge_action(id)
      else
        redirect(:show_sports)
        stop_thread
      end
    end
  end

  def handle_no_sports_available
    @api = Api.new
    @api.fetch_user(user.id)
    #TODO possibly add a call to special list of matchups in exchange for sweepcoins

    options = [
      {
        text: "No overtime here...yet ⏳\n\nBut I bet one of your friends would ❤️ to try to take you in a challenge 🙊💰",
        quick_replies: ["Status", "Challenges"]
      },
      {
        text: "I'm still thinkin' about what I want to add for you next 🤔\n\nI promise to bug you as soon as I add more games 🐞",
        quick_replies: ["Status", "Notifications"]
      },
      { 
        text: "Donezo. Kaput. Finito.\n\nBut, we can always email each other if things get real bad...I'll even throw in 🖐 Sweepcoins 🙂", 
        quick_replies: ["Status", "Email me 💌"]
      },
      { 
        text: "No new games just yet 🤷‍♀️\n\nBut you can call your parents, they miss you...and you can tell em' about your picks ☎️", 
        quick_replies: ["Status", "Invite friends"]
      }
    ]
    sample = options.sample
    say sample.text, quick_replies: sample.quick_replies
    stop_thread
  end

  def handle_prop
    if message.quick_reply == 'NO'
      options = [
        {text: "Sounds good 👍, you can always come back later!"}
      ]
      say "Sounds good 👍, "
      stop_thread
    else
      user.session[:game_type] = 'prop'
      handle_pick
    end
  end

  def handle_pick
    say "Cool 😎📷\nJust type 'make picks' to get back to selecting 👍" and stop_thread and return if message.text.nil?
    @api = Api.new
    @api.fetch_user(user.id)
    qr = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    say "Make sure you tap the team bubbles when making your picks so I can track em' properly 😉", quick_replies: ["Select picks", "Status"] and stop_thread and return if (!message.quick_reply && message.text)
    show_button("Show Challenges", "Sorry, I was too focused on making picks 🙈\n\nTap below to respond to any pending challenges 👇", qr, "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}") and stop_thread and return if (message.quick_reply.split(' ')[1] == 'CHALLENGE')
    sport, matchup_id, selected_id = get_sport(message.quick_reply), get_matchup_id(message.quick_reply), get_selected_id(message.quick_reply) unless message.quick_reply.nil?
    return if message.quick_reply.nil?
    skip and return if message.quick_reply.split(' ')[0] == "Skip"
    @api.fetch_all('matchups', user.id, sport.downcase, user.session[:game_type]) unless sport.nil?
    if user.session[:game_type] == 'game'
      if @api.matchups && @api.matchups.count > 1 || @api.matchups && @api.matchups.count == 0
        games = 'games'
      else
        games = 'game'
      end
    elsif user.session[:game_type] == 'prop'
      if @api.matchups && @api.matchups.count > 1 || @api.matchups && @api.matchups.count == 0 
        games = 'props'
      else
        games = 'prop'
      end
    end
    count = @api.matchups && @api.matchups.count
    count != 0 && count == 1 ? context_count = "this" : context_count = "these #{count}"
    options = [
      "Holy smokes 💨, have I got #{count} great #{sport.capitalize} #{games} for you #{@api.user.first_name}!",
      "#{count} #{sport.capitalize} #{games} comin' right up! Time to get out your crystal ball 🔮",
      "I've got a feeling you're gonna crush #{context_count} #{sport.capitalize} #{games} 🎲",
      "Think you know about #{sport.capitalize}? Here's your chance to prove it with #{context_count} #{games} right here 🥇",
      "Don't be afraid to call 'em like you see it #{@api.user.first_name}, #{count} #{games} on deck 😉",
      "I have #{count} #{sport.capitalize} #{games} for ya, show me what you got #{@api.user.first_name} 🏋️",
      "The #{sport.capitalize} SAT starts now...think you can do better than you did back in high school? 🤐",
      "Welcome to your own personal #{sport.capitalize} Vegas 🤑"
    ]
    short_wait(:message)
    say options.sample unless (matchup_id && selected_id || (@api.matchups.nil? || @api.matchups.empty?))
    if matchup_id && selected_id
      params = { :pick => {:user_id => @api.user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
      @api.create('picks', user.id, params)
      short_wait(:message)
      say "+1 Sweepcoin for your Daily Pick 💰!" unless @api.user.daily.picked
      short_wait(:message)
      say "#{@api.pick.selected} ✅" unless @api.pick.nil?
      @api.fetch_all('matchups', user.id, sport.downcase, user.session[:game_type]) unless sport.nil?
      short_wait(:message)
      fetch_matchup(sport, @api.matchups && @api.matchups.first)
      update_user_info unless @api.user.daily.picked
    else
      @api.fetch_all('matchups', user.id, sport.downcase, user.session[:game_type]) unless sport.nil?
      fetch_matchup(sport, @api.matchups && @api.matchups.first)
    end
  end

  def skip
    @api = Api.new
    @api.fetch_user(user.id)  
    sport, matchup_id = get_sport(message.quick_reply), get_matchup_id(message.quick_reply) unless message.quick_reply.nil?
    @api.update('matchups', matchup_id, { :matchup => {:skipped_by => @api.user.id} })
    options = ["Skipped 👍", "You can always come back later and pick 🙌", "You got it 😉", "Done 🤝"]
    message.typing_on
    sleep 0.5
    say options.sample
    sleep 0.5
    message.typing_on
    sleep 1
    @api.fetch_all('matchups', user.id, sport.downcase, user.session[:game_type]) unless sport.nil?
    fetch_matchup(sport, @api.matchups && @api.matchups.first)
  end

  def fetch_matchup sport, matchup
    if (matchup.nil? || matchup.empty?) && user.session[:game_type] == "prop"
      options = [
        { 
          text: "You're all caught up on #{sport.capitalize}! Good luck out there 😇", 
          quick_replies: ["More sports", "Status"]
        }, 
        { 
          text: "You did it! You're practically a GM now 👔", 
          quick_replies: ["More sports", "Status", "Invite friends"]
        },
        { 
          text: "I got your #{sport.capitalize} picks in! Sit back, relax, and let Emma help you to a Sweep 💰\n\nOh, and if you have anymore friends out there, get em' on board and earn some Sweepcoins 😉", 
          quick_replies: ["More sports", "Status", "Invite friends"]
        },
        { 
          text: "That's all she wrote for #{sport.capitalize}...for now ☺️\n\nDon't forget to get out there and challenge your friends!", 
          quick_replies: ["More sports", "Status", "Challenges"]
        },
        { 
          text: "Phew, that was tiring...even for someone as energetic as muah 😘\n\nI'll make sure to let you know when I find some more games ⏰", 
          quick_replies: ["More sports", "Status", "Notifications"]
        },
        { 
          text: "No more #{sport.capitalize} games!\n\nMake sure you have new game reminders turned on, or check back later ⏰", 
          quick_replies: ["More sports", "Status", "Notifications"]
        },
        { 
          text: "All finished with #{sport.capitalize}!\n\nWant more action? Challenge your friends for some Sweepcoins...and bragging rights 🤑💪", 
          quick_replies: ["More sports", "Status", "Challenges"]
        },
        { 
          text: "Do your fingers ever get tired? My brain does 😴💤\n\nWe should both take a rest and enjoy the games 😊", 
          quick_replies: ["More sports", "Status"]
        },
      ]
      sample = options.sample
      say sample.text, quick_replies: sample.quick_replies
      stop_thread
    elsif (matchup.nil? || matchup.empty?) && user.session[:game_type] == "game" 
      options = ["All done, wanna take some #{sport} props?", "No more #{sport} games, did you want to make some prop picks?"]
      say options.sample, quick_replies: [["Yes", "#{sport}"], ["No", "NO"]]
      next_command :handle_prop
    else
      away = matchup.away_side
      home = matchup.home_side
      quick_replies = [
        { content_type: 'text', title: "#{away.action}", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
        { content_type: 'text', title: "#{home.action}", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
        { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
      ]
      if matchup.type == "Game"
        short_wait(:message)
        say "Starting #{matchup.custom_time}\n#{matchup.display_time}"
        short_wait(:message)
        show_media(matchup.attachment_id, quick_replies)
        next_command :handle_pick
      elsif matchup.type == "Prop"
        say "#{matchup.context}\n\n"
        short_wait(:message)
        say "🏈 #{away.action} or #{home.action}\n\nStarting #{matchup.custom_time}\n📅 #{matchup.display_time}", quick_replies: quick_replies
        next_command :handle_pick
      end
    end
  end

  def update_user_info
    conn = Faraday.new(:url => "https://graph.facebook.com/v2.9/#{user.id}?fields=profile_pic,gender,timezone&access_token=#{ENV['ACCESS_TOKEN']}")
    response = conn.get
    fb_user = JSON.parse(response.body)
    params = { :user => 
      { 
        :profile_pic => fb_user.has_key?('profile_pic') ? fb_user.profile_pic : nil, 
        :gender => fb_user.has_key?('gender') ? fb_user.gender : nil, 
        :timezone => fb_user.has_key?('timezone') ? fb_user.timezone : nil 
      } 
    }
    @api = Api.new
    @api.update('users', user.id, params)
  end

  def get_sport payload
    if payload.split(' ')[0] == 'Skip'
      if payload.split(' ').length == 3
        payload.split(' ')[1]
      else
        payload.gsub(/\d+/,"").strip.split(' ')[1..-1].join(' ')
      end
    else
      if payload.split(' ').length == 1 || payload.split(' ').length == 3
        payload.split(' ')[0]
      else
         payload.gsub(/\d+/,"").strip
      end
    end
  end

  def get_matchup_id payload
    if payload.split(' ').length == 1 || payload.split(' ').length == 2
      return nil
    elsif payload.split(' ')[0] == 'Skip'
      payload.split(' ')[-1]
    else
      payload.split(' ')[-2]
    end
  end

  def get_selected_id payload
    if payload.split(' ').length == 1 || payload.split(' ').length == 2
      return nil
    elsif payload.split(' ')[0] == 'Skip'
      return nil
    else
      payload.split(' ')[-1]
    end
  end
end
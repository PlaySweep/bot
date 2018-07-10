module Commands
  def handle_show_sports
    @api = Api.new
    @api.fetch_sports
    if @api.sports.map(&:name).map(&:upcase).include?(message.quick_reply)
      puts "SPORTS: #{@api.sports.inspect}"
      user.session[:game_type] = 'game'
      user.session[:sport_emoji] = @api.sports.find { |sport| sport["name"].upcase == message.quick_reply }["emoji"]
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
    quick_replies = [["Status", "Challenges"], ["Status", "Notifications"], ["Status", "Email me 💌"], ["Status", "Invite friends"], ["Status", "Sweepcoins"], ["Status", "Earn coins"]]

    options = [
      "Time is a flat circle and we're back here again. Check back later for more games 🕛",
      "If we're using our made-up names, I'm Spider-Man. You can be Dr. Strange. I'll message when I have more for you, Dr. Strange 🕷",
      "Looks like you're stuck in the sunken place, no more games left to be picked.",
      "You're done with picks for now, but don't ever leave me. Cause I'd find you...😜",
      "No more games to pick here, maybe your mom has some meatloaf?",
      "Nothing else available, gonna grab my wolfpack and hit the desert in Vegas",
      "Our work is done here, but imagine what a little Vibranium could do...",
      "If you ever take me to California, I hope you mean Coachella. All done for now.",
      "You're all caught up across the board. I'll have more games soon.",
      "No more games to pick here, now is your time to think about how you'd take down a Demigorgon 🤔",
      "No more games for now, I promise I won’t keep you waiting as long as the post office 📫",
      "You’ve made your picks. Now go make peace with that printer upstairs that never works 🙄",
      "All finished...what? Expecting another joke or something? 😝",
      "No more games yet....and no, you can’t ask me to help you carry your couch when you move. I'm a bot. 🤖"
    ]
    say options.sample, quick_replies: quick_replies.sample
    stop_thread
  end

  def handle_prop
    if message.quick_reply == 'NO'
      options = [
        {
          text: "Sounds good 👍\n\nYou can always come back later and pick!", 
          quick_replies: ['More sports', 'Status']
        }
      ]
      option = options.sample
      say option.text, quick_replies: option.quick_replies
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
        games = 'games'
      else
        games = 'game'
      end
    end
    count = @api.matchups && @api.matchups.count
    options = [
      "#{count} #{user.session[:sport_emoji]} #{games} on deck...",
      "#{count} #{user.session[:sport_emoji]} #{games} comin up...",
      "#{count} #{user.session[:sport_emoji]} #{games} today...",
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
    options = ["Skipped 👍", "You can always come back later and pick 🙌", "You got it 😉", "Okay 😎"]
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
    options = ["Done with #{user.session[:sport_emoji]}", "Finished with #{user.session[:sport_emoji]}", "Completed #{user.session[:sport_emoji]}"]
    quick_replies = [["More sports", "Status", "Sweepcoins"], ["More sports", "Status", "Invite friends"], ["More sports", "Status", "Challenges"]]
    if (matchup.nil? || matchup.empty?) && user.session[:game_type] == "prop"
      say options.sample, quick_replies: quick_replies.sample
      stop_thread
    elsif (matchup.nil? || matchup.empty?) && user.session[:game_type] == "game" 
      @api.fetch_all('matchups', user.id, sport.downcase, 'prop') unless sport.nil?
      if (@api.matchups.nil? || @api.matchups.empty?)
        say options.sample, quick_replies: quick_replies.sample
        stop_thread
      else
        say "Pick some #{user.session[:sport_emoji]} side plays?", quick_replies: [["Yes", "#{sport}"], ["No", "NO"]]
        next_command :handle_prop
      end
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
        say "#{away.action} or #{home.action}\n\nStarting #{matchup.custom_time}\n#{matchup.display_time}", quick_replies: quick_replies
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
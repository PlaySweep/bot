module Commands
  def handle_challenge_intro
    #TODO update unexpected response messaging
    say "Ahh yep, sorry that was my bad...head back into challenges to accept or decline your friends request 👍", quick_replies: ['Challenges'] and stop_thread and return if (['accept', 'decline'].include?(message.text.downcase.split(' ')[0]))
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE FRIENDS'
      @api = Api.new
      @api.fetch_friends(user.id)
      quick_replies = build_payload_for('users', @api.friends)
      message.typing_on
      say "Tap your friend below or search 👇", quick_replies: quick_replies.unshift("Search friends?")
      message.typing_off
      next_command :handle_selected_challenge
    when 'MY CHALLENGES'
      @api = Api.new
      @api.fetch_user(user.id)
      if @api.user.pending_challenges.size > 0 || @api.user.active_challenges.size > 0
        challenges = @api.user.pending_challenges.concat(@api.user.active_challenges)
        build_text_for(resource: :challenges, object: challenges, options: :message)
        quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
        short_wait(:message)
        #TODO make api call to populate random category gif
        show_media_with_button(user.id, 'challenges', [1261118024018248, 1261118190684898, 1261118400684877].sample, quick_replies)
        stop_thread
      else
        short_wait(:message)
        say "No challenges in flight 🛬", quick_replies: ['Challenges', 'Select picks', 'Status']
        stop_thread
      end
    end
  end

  def handle_challenge_intro_postback
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE FRIENDS'
      @api = Api.new
      @api.fetch_friends(user.id)
      quick_replies = build_payload_for('users', @api.friends)
      message.typing_on
      say "Tap your friend below or search 👇", quick_replies: quick_replies.unshift("Search friends?")
      message.typing_off
      next_command :handle_selected_challenge
    when 'MY CHALLENGES'
      @api = Api.new
      @api.fetch_user(user.id)
      if @api.user.pending_challenges.size > 0 || @api.user.active_challenges.size > 0
        challenges = @api.user.pending_challenges.concat(@api.user.active_challenges)
        build_text_for(resource: :challenges, object: challenges, options: :message)
        quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
        short_wait(:message)
        #TODO make api call to populate random category gif
        show_media_with_button(user.id, 'challenges', [1261118024018248, 1261118190684898, 1261118400684877].sample, quick_replies)
        stop_thread
      else
        say "No challenges in flight 🛬", quick_replies: ['Challenges', 'Select picks', 'Status']
        stop_thread
      end
    end
  end

  def handle_query_matchups
    short_wait(:message)
    if user.session[:matchup_searches] && user.session[:matchup_searches] > 0
      quick_replies = [{ content_type: 'text', title: "Nevermind", payload: "NEVERMIND" }]
      url = "#{ENV['WEBVIEW_URL']}/matchups/#{user.id}"
      show_button("Available Games", "Need a sneak peek? Check the available games and then tell me what matchup you want and I'll select it for you 😉", quick_replies, url)
      next_command :handle_find_matchup
    else
      example = ["Lakers or Tom Brady", "Yankees or Lebron James"]
      say "Tell me what matchup you're looking for, like #{example.sample} and I'll find it for you 😉", quick_replies: ['Nevermind']
      next_command :handle_find_matchup
    end
  end

  def handle_query_users
    short_wait(:message)
    say "Type your friends name below and I'll go find em' 👇", quick_replies: ["Nevermind"]
    next_command :handle_find_friend
  end

  def handle_find_friend
    #TODO some weird logic on getting out of this loop when wanting to quit before typing friends name
    say "Invite your friends to get started with challenges 👍", quick_replies: ["Invite friends", "Select picks", "Status"] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    @api = Api.new
    @api.fetch_user(user.id)
    @api.query_users(strip_emoji(message.text))
    if @api.user_list.map(&:full_name).empty?
      quick_replies = ["Invite friends", "Try again", "Nevermind"]
      friend = message.text
      say "If your friend isn't showing up, they probably haven't started a conversation with us yet. Invite them to get started 👍", quick_replies: quick_replies
      next_command :handle_selected_challenge
    else
      quick_replies = build_payload_for('users', @api.user_list)
      say "Tap on a friend to challenge them 👍", quick_replies: quick_replies.concat(["Try again", "Nevermind"])
      next_command :handle_selected_challenge
    end
  end

  def handle_find_matchup
    say "Invite your friends to get started with challenges 👍", quick_replies: ["Invite friends", "Select picks", "Status"] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    @api = Api.new
    @api.fetch_user(user.id)
    matchups = @api.query_matchups(strip_emoji(message.text))
    if matchups.size > 0
      matchup = matchups.first
      case matchup.type
      when 'Game'
        say "#{matchup.description}", quick_replies: [["#{matchup.away_side.abbreviation} (#{matchup.away_side.action})", "#{matchup.id} #{matchup.away_side.id}"], ["#{matchup.home_side.abbreviation} (#{matchup.home_side.action})", "#{matchup.id} #{matchup.home_side.id}"]]
        user.session[:challenge_details][:selected_side_type] = :game
        user.session[:matchup_searches] = 0
        next_command :handle_wager_input
      when 'Prop'
        say "#{matchup.description}", quick_replies: [["#{matchup.away_side.abbreviation}", "#{matchup.id} #{matchup.away_side.id}"], ["#{matchup.home_side.abbreviation}", "#{matchup.id} #{matchup.home_side.id}"]]
        user.session[:challenge_details][:selected_side_type] = :prop
        user.session[:matchup_searches] = 0
        next_command :handle_wager_input
      end
    else
      user.session[:matchup_searches] = 1
      say "Couldn't find a pending matchup based on that search..."
      short_wait(:message)
      handle_query_matchups
    end
  end

  def type_wager_amount
    say "Type in your wager amount below 🤑"
    next_command :handle_wager_response
  end

  def handle_wager_input
    handle_query_matchups and return if !message.quick_reply
    @api = Api.new
    @api.fetch_user(user.id)
    matchup_id = message.quick_reply.split(' ')[0]
    selected_team_id = message.quick_reply.split(' ')[-1]
    case user.session[:challenge_details][:selected_side_type]
    when :game
      selection = @api.fetch_team(selected_team_id)
    when :prop
      selection = @api.fetch_prop(selected_team_id)
    end
    user.session[:challenge_details][:matchup_id] = matchup_id
    user.session[:challenge_details][:selected_team_id] = selected_team_id
    friend = user.session[:challenge_details][:full_name]
    say "#{selection.name} ✅"
    short_wait(:message)
    say "With a pending Sweepcoin balance of #{@api.user.data.pending_balance}"
    short_wait(:message)
    type_wager_amount
  end

  def handle_wager_input_for_duration
    @api = Api.new
    @api.fetch_user(user.id)
    say "With a pending Sweepcoin balance of #{@api.user.data.pending_balance}"
    short_wait(:message)
    type_wager_amount
  end

  def retry_wager_input
    say "Type in the wrong wager amount?", quick_replies: [['Yes', 'YES'], ['Changed my mind', 'NO']]
    next_command :handle_retry_wager_input
  end

  def handle_retry_wager_input
    say "Ok no worries, you can come back later or start over 😉", quick_replies: ['Challenges', 'Select picks'] and stop_thread and return if !message.quick_reply
    case message.quick_reply
    when 'YES'
      short_wait(:message)
      type_wager_amount
    when 'NO'
      clear_challenge
    end
  end

  def handle_wager_response
    @api = Api.new
    @api.fetch_user(user.id)
    friend = user.session[:challenge_details][:full_name]
    if message.text.to_i == 0
      say "You sure you want to wager #{friend} for 0 Sweepcoins?", quick_replies: ["Send it", "No, I screwed up"]
      next_command :confirm_challenge_details
    elsif @api.user.data.pending_balance >= message.text.to_i
      user.session[:challenge_details][:coins] = message.text.to_i
      say "Great! You ready to challenge #{friend} for #{message.text} Sweepcoins?", quick_replies: ["Send it", "No, I screwed up"]
      next_command :confirm_challenge_details
    else
      say "You do not have enough Sweepcoins to wager that amount, try typing a new amount below", quick_replies: ["Earn coins", "Earn coins"]
      short_wait(:message)
      type_wager_amount
    end
  end

  def handle_selected_challenge
    handle_query_users and return if !message.quick_reply
    show_invite and stop_thread and return if message.quick_reply == 'INVITE FRIENDS'
    say "Invite your friends to get started with challenges 👍", quick_replies: ["Invite friends", "Select picks", "Status"] and stop_thread and return if message.quick_reply == "NEVERMIND"
    case message.quick_reply
    when 'SEARCH FRIENDS?'
      handle_query_users
    when 'TRY AGAIN'
      handle_query_users
    else
      id = eval(message.quick_reply.split(' ')[-1])
      if id.to_i == user.id.to_i
        short_wait(:message)
        say "Hehe ☺️"
        medium_wait(:message)
        say "I agree, challenging yourself really is the only way to grow...\n\nBut for today, you'll have to stick to friends 😉"
        short_wait(:message)
        handle_query_users
      else
        user.session[:challenge_details] = {}
        user.session[:challenge_details][:attempts] = 0
        friend = message.text
        user.session[:challenge_details][:full_name] = friend
        user.session[:challenge_details][:user_id] = id
        say "What kind of challenge would you like to send #{friend.split(' ')[0]}?", quick_replies: ["Matchup", "Most wins"]
        next_command :handle_challenge_type
      end
    end
  end

  def handle_challenge_type
    say "I don't recognize that type of challenge, try again?", quick_replies: ['Most Wins', 'Matchup', 'Nevermind'] and next_command :handle_challenge_type if !message.quick_reply
    case message.quick_reply
    when 'MOST WINS'
      @api = Api.new
      @api.fetch_challenge_type(message.quick_reply.downcase)
      user.session[:challenge_details][:type_id] = @api.challenge_type.id
      say "How long would you like the duration of this challenge to be?", quick_replies: ["3 days", "A week", "A month"]
      next_command :handle_duration_challenge_details
    when 'MATCHUP'
      @api = Api.new
      @api.fetch_challenge_type(message.quick_reply.downcase)
      user.session[:challenge_details][:type_id] = @api.challenge_type.id
      handle_query_matchups
    when 'NEVERMIND'
      say "Ok 😇", quick_replies: ['Select picks', 'Status']
      user.session[:challenge_details] = {}
      stop_thread
    end
  end

  def handle_duration_challenge_details
    retry_duration_details if !message.quick_reply
    case message.quick_reply
    when '3 DAYS'
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = 3
      say "I've got a #{user.session[:challenge_details][:days]} day challenge for the most wins against #{full_name}..."
      short_wait(:message)
      handle_wager_input_for_duration
    when 'A WEEK'
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = 7
      say "I've got a #{user.session[:challenge_details][:days]} day challenge for the most wins against #{full_name}..."
      short_wait(:message)
      handle_wager_input_for_duration
    when 'A MONTH'
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = 30
      say "I've got a #{user.session[:challenge_details][:days]} day challenge for the most wins against #{full_name}..."
      short_wait(:message)
      handle_wager_input_for_duration
    end
  end

  def retry_duration_details
    days = message.text.split(' ').map(&:to_i).sort.reverse.first
    if days > 0
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = days
      say "I've got a #{user.session[:challenge_details][:days]} day challenge for the most wins against #{full_name}..."
      short_wait(:message)
      handle_wager_input_for_duration
    else
      say "I'm not sure I'm pickin up what you're throwin down 🤔\n\nTry that one more time...", quick_replies: ["3 days", "A week", "A month"]
      next_command :handle_duration_challenge_details
    end
  end

  def retry_challenge_confirmation
    user.session[:challenge_details][:attempts] += 1
    say "Did you forget to tap the options below?\n\nConfirm your challenge with #{user.session[:challenge_details][:full_name]} by sending over a message ✉️", quick_replies: ["Send it", "No, I screwed up"]
    next_command :confirm_challenge_details
  end

  def clear_challenge
    say "Ok 😇", quick_replies: ['Select picks', 'Status']
    user.session[:challenge_details] = {}
    stop_thread
  end

  def confirm_challenge_details
    clear_challenge and return if !message.quick_reply && user.session[:challenge_details][:attempts] == 1
    retry_challenge_confirmation if !message.quick_reply && user.session[:challenge_details][:attempts] == 0
    case message.quick_reply
    when 'SEND IT'
      if user.session[:challenge_details][:days]
        params = { 
          :challenge => {
            :friend_id => user.session[:challenge_details][:user_id], 
            :challenge_type_id => user.session[:challenge_details][:type_id], 
            :days => user.session[:challenge_details][:days],
            :coins => user.session[:challenge_details][:coins]
          } 
        }
        send_challenge_request(user.id, params)
        say "Sent! We'll let you know when they accept 👍", quick_replies: ["Challenges", "Select picks", "Status"]
        user.session[:challenge_details] = {}
        stop_thread
      else
        params = { 
          :challenge => {
            :friend_id => user.session[:challenge_details][:user_id], 
            :challenge_type_id => user.session[:challenge_details][:type_id], 
            :matchup_id => user.session[:challenge_details][:matchup_id],
            :selected_team_id => user.session[:challenge_details][:selected_team_id],
            :coins => user.session[:challenge_details][:coins]
          } 
        }
        send_challenge_request(user.id, params)
        say "Sent! We'll let you know when they accept 👍", quick_replies: ["Challenges", "Select picks", "Status"]
        user.session[:challenge_details] = {}
        stop_thread
      end
    when 'NO, I SCREWED UP'
      retry_wager_input
    end
  end
end
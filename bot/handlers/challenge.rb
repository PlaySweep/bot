module Commands
  def handle_challenge_intro
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
      quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      if @api.user.challenges.size > 0
        payload = build_card_for(:challenge, @api.user.challenges)
        show_carousel(payload, quick_replies)
        stop_thread
      else
        text = "No challenges in flight 🛬\n\nTap below to view any pending challenges 👇"
        quick_replies = [{ content_type: 'text', title: "Challenges", payload: "CHALLENGES" }, { content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
        url = "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}"
        show_button("Show Challenges", text, quick_replies, url)
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
      quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      if @api.user.challenges.size > 0
        payload = build_card_for(:challenge, @api.user.challenges)
        show_carousel(carousel, quick_replies)
        stop_thread
      else
        text = "No challenges in flight 🛬\n\nTap below to view any pending challenges 👇"
        quick_replies = [{ content_type: 'text', title: "Challenges", payload: "CHALLENGES" }, { content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
        url = "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}"
        show_button("Show Challenges", text, quick_replies, url)
        stop_thread
      end
    end
  end

  def handle_query_matchups
    message.typing_on
    #TODO text_button that shows list of available matchups to challenge
    text = "Type out the team/prop you want to challenge with below 👇"
    quick_replies = [{ content_type: 'text', title: "Nevermind", payload: "NEVERMIND" }]
    url = "#{ENV['WEBVIEW_URL']}/matchups"
    show_button("Show Matchups", text, quick_replies, url)
    # say "You can type in the name of the team/prop you're interested in challenging with below 👇", quick_replies: ["Nevermind"]
    message.typing_off
    next_command :handle_find_matchup
  end

  def handle_query_users
    message.typing_on
    say "Ok, type in your friends name below 👇", quick_replies: ["Nevermind"]
    message.typing_off
    next_command :handle_find_friend
  end

  def handle_find_friend
    say "Invite your friends to get started with challenges 👍", quick_replies: ["Invite friends", "Select picks", "Status"] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    @api = Api.new
    @api.fetch_user(user.id)
    @api.query_users(message.text)
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
    matchups = @api.query_matchups(message.text)
    if matchups.size == 1
      matchup = matchups.first
      say "Which side of #{matchup.description} do you want to pick?", quick_replies: [["#{matchup.away_side.abbreviation} (#{matchup.away_side.action})", "#{matchup.id} #{matchup.away_side.id}"], ["#{matchup.home_side.abbreviation} (#{matchup.home_side.action})", "#{matchup.id} #{matchup.home_side.id}"]]
      next_command :handle_wager_input
    else
      say "Couldn't find a pending matchup based on that search..."
      short_wait(:message)
      #TODO show matchup options
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
    selection = @api.fetch_team(selected_team_id)
    user.session[:challenge_details][:matchup_id] = matchup_id
    user.session[:challenge_details][:selected_team_id] = selected_team_id
    friend = user.session[:challenge_details][:full_name]
    say "#{selection.name} ✅"
    short_wait(:message)
    say "You currently have a pending balance of #{@api.user.data.pending_balance} Sweepcoins..."
    short_wait(:message)
    type_wager_amount
  end

  def handle_wager_input_for_duration
    @api = Api.new
    @api.fetch_user(user.id)
    say "You currently have a pending balance of #{@api.user.data.pending_balance} Sweepcoins..."
    short_wait(:message)
    type_wager_amount
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
      user.session[:challenge_details] = {}
      friend = message.text
      user.session[:challenge_details][:full_name] = friend
      id = eval(message.quick_reply.split(' ')[-1])
      user.session[:challenge_details][:user_id] = id
      say "What kind of challenge would you like to send #{friend.split(' ')[0]}?", quick_replies: ["Matchup", "Most wins"]
      next_command :handle_challenge_type
    end
  end

  def handle_challenge_type
    case message.quick_reply
    when 'MOST WINS'
      user.session[:challenge_details][:type_id] = 1
      say "How long would you like the duration of this challenge to be?", quick_replies: ["3 days", "A week", "A month"]
      next_command :handle_duration_challenge_details
    when 'MATCHUP'
      user.session[:challenge_details][:type_id] = 2
      handle_query_matchups
    end
  end

  def handle_duration_challenge_details
    #TODO capture error messages
    case message.quick_reply
    when '3 DAYS'
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = 3
      say "You are challenging #{full_name} to the most wins within a 3 day span..."
      short_wait(:message)
      handle_wager_input_for_duration
    when 'A WEEK'
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = 7
      say "You are challenging #{full_name} to the most wins within a 7 day span..."
      short_wait(:message)
      handle_wager_input_for_duration
    when 'A MONTH'
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = 30
      say "You are challenging #{full_name} to the most wins within a 30 day span..."
      short_wait(:message)
      handle_wager_input_for_duration
    end
  end

  def confirm_challenge_details
    #TODO capture error responses
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
      say "Ok no worries, you can come back later or start over 😉", quick_replies: ['Challenges', 'Select picks']
      stop_thread
    end
  end
end
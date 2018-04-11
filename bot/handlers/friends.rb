module Commands
  def handle_friends
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE A FRIEND'
      @api = Api.new
      @api.fetch_friends(user.id)
      quick_replies = build_payload_for('users', @api.friends)
      message.typing_on
      say "👇", quick_replies: quick_replies.push("Search friends?")
      message.typing_off
      next_command :handle_challenge
    end
  end

  def handle_friends_postback
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE A FRIEND'
      @api = Api.new
      @api.fetch_friends(user.id)
      quick_replies = build_payload_for('users', @api.friends)
      message.typing_on
      say "👇", quick_replies: quick_replies.push("Search friends?")
      message.typing_off
      next_command :handle_challenge
    end
  end

  def handle_challenge_request
    say "Cold feet, huh? All good." and stop_thread and return if !message.quick_reply.split(' ')[-1].is_a?(Integer)
    id = eval(message.quick_reply.split(' ')[-1])
    send_challenge_request(user.id, id)
    say "Great! I've sent a your challenge to #{message.text}. Let's hope things work out, or else this was awkward...", quick_replies: ["Challenge friends", "Select picks", "Status"]
    stop_thread
  end

  def handle_query_users
    message.typing_on
    say "Ok, type in the friend you're looking for 👇", quick_replies: ["Nevermind"]
    message.typing_off
    next_command :handle_confirm_friend
  end

  def handle_confirm_friend
    say "Invite your friends to get started with challenges 👍", quick_replies: ["Invite friends", "Select picks", "Status"] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    @api = Api.new
    @api.fetch_user(user.id)
    @api.query_users(message.text)
    if @api.user_list.map(&:full_name).empty?
      quick_replies = ["Invite friends", "Try again", "Nevermind"]
      friend = message.text
      say "If your friend isn't showing up, they probably haven't started a conversation with us yet. Invite them to get started 👍", quick_replies: quick_replies
      next_command :handle_challenge
    else
      quick_replies = build_payload_for('users', @api.user_list)
      say "Tap on a friend to challenge them 👍", quick_replies: quick_replies
      next_command :handle_challenge
    end
  end

  def handle_challenge
    say "Type 'Add friends' to send a friend request 👍", quick_replies: ["Select picks", "Status"] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    say "If your friend isn't showing up, they probably haven't started a conversation with us yet. Invite them to get started 👍", quick_replies: ["Invite friends", "Try again", "Nevermind"] and stop_thread and return if !message.quick_reply
    show_invite and stop_thread and return if message.quick_reply == 'INVITE FRIENDS'
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
      next_command :handle_confirm_challenge
    end
  end

  def handle_confirm_challenge
    case message.quick_reply
    when 'MOST WINS'
      user.session[:challenge_details][:type_id] = 1
      say "What would you like the duration of this challenge to be?", quick_replies: ["3 days", "A week", "A month"]
      next_command :handle_challenge_details
    when 'MATCHUP'
      user.session[:challenge_details][:type_id] = 2
      # card list of matchups carousel
      show_carousel
      stop_thread
    end
  end

  def handle_challenge_details
    case message.quick_reply
    when '3 DAYS'
      full_name = user.session[:challenge_details][:full_name]
      user.session[:challenge_details][:days] = 3
      say "So you are challenging #{full_name} to the most wins in 3 days, you good?", quick_replies: ["Send it", "No, I screwed up"]
      next_command :confirm_challenge_details
    end
  end

  def confirm_challenge_details
    case message.quick_reply
    when 'SEND IT'
      params = { 
        :challenge => {
          :friend_id => user.session[:challenge_details][:user_id], 
          :challenge_type_id => user.session[:challenge_details][:type_id], 
          :days => user.session[:challenge_details][:days],
          :coins => 15
        } 
      }
      send_challenge_request(user.id, params)
      say "Sent! We'll let you know when they accept 👍", quick_replies: ["Challenge more friends", "Select picks", "Status"]
      stop_thread
    end
  end
end
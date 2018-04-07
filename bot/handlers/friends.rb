module Commands
  def handle_friends
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE A FRIEND'
      @api = Api.new
      @api.fetch_user(user.id)
      quick_replies = @api.user.friends.map(&:full_name).first(4).push("Search friends?")
      message.typing_on
      say "👇", quick_replies: quick_replies
      message.typing_off
      next_command :handle_challenge
    end
  end

  def handle_friends_postback
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE A FRIEND'
      @api = Api.new
      @api.fetch_user(user.id)
      quick_replies = @api.user.friends.map(&:full_name).first(4).push("Search friends?")
      message.typing_on
      say "👇", quick_replies: quick_replies
      message.typing_off
      next_command :handle_challenge
    end
  end

  # def handle_try_again
  #   say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
  #   case message.quick_reply
  #   when 'TRY AGAIN'
  #     message.typing_on
  #     say "Let's try that one more time..."
  #     message.typing_off
  #     next_command :handle_user_lookup
  #   when 'NO THANKS'
  #     message.typing_on
  #     say "Ok, carry on with your life"
  #     message.typing_off
  #     stop_thread
  #   end
  # end

  # def handle_user_lookup
  #   say "Ok, carry on with your life" and stop_thread and return if (message.quick_reply && message.quick_reply == "NO THANKS")
  #   @api = Api.new
  #   @api.fetch_user(user.id)
  #   @api.query_users(message.text)
  #   quick_replies = @api.user_list.map(&:full_name)
  #   found_ids = []
  #   if @api.user_list.empty?
  #     say FRIEND_LOOKUP.sample, quick_replies: ["Invite friends", "Try again", "No thanks"]
  #     next_command :handle_try_again
  #   else
  #     if quick_replies.length > 1
  #       quick_replies = quick_replies.each_slice(1).to_a.each_with_index do |user, index|
  #         user.push("#{@api.user_list[index].full_name} #{@api.user_list[index].facebook_uuid}")
  #         found_ids.push(@api.user_list[index].facebook_uuid)
  #       end
  #       quick_replies.unshift(["Add everyone", "EVERYONE #{found_ids}"])
  #     else
  #       quick_replies = quick_replies.each_slice(1).to_a.each_with_index do |user, index|
  #         user.push("#{@api.user_list[index].full_name} #{@api.user_list[index].facebook_uuid}")
  #       end
  #     end
  #     puts "Quick replies => #{quick_replies.inspect}"
  #     say "Tap on the name(s) below to send a friend request. Once they accept, you'll be able to challenge each other. Don't worry, I'll send you an update on the status of your friendship.", quick_replies: quick_replies
  #     next_command :handle_challenge_request
  #   end
  # end

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
      quick_replies = @api.user_list.map(&:full_name).first(3).each_slice(1).to_a.each_with_index do |user, index|
        user.push("#{@api.user_list[index].full_name} #{@api.user_list[index].facebook_uuid}")
      end
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
      friend = message.text
      id = eval(message.quick_reply.split(' ')[-1])
      say "What kind of challenge would you like to send #{friend.split(' ')[0]}?", quick_replies: [["Highest streak", "HIGHEST STREAK #{id}"], ["Most wins", "MOST WINS #{id}"]]
      next_command :handle_confirm_challenge
    end
  end

  def handle_confirm_challenge
    case message.quick_reply.split(' ')[0...-1].join(' ')
    when 'HIGHEST STREAK'
      id = eval(message.quick_reply.split(' ')[-1])
      puts "Send challenge to #{id}"
      # send_challenge_request(user.id, id)
      say "Here are the rules for highest streak..."
      stop_thread
    when 'MOST WINS'
      say "Here are the rules for most wins..."
      stop_thread
    end
  end
end
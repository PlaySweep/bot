module Commands
  def handle_friends
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE A FRIEND'
      @api = Api.new
      @api.find_or_create('users', user.id)
      quick_replies = @api.user.friends.map(&:full_name).first(3).push("Search friends?")
      message.typing_on
      say "👇", quick_replies: quick_replies
      message.typing_off
      next_command :handle_challenge
    when 'FIND FRIENDS'
      message.typing_on
      say "You can search for up to 5 at a time, adding em all in one fell swoop 😉"
      message.typing_off
      message.typing_on
      say "👇"
      next_command :handle_user_lookup
    end
  end

  def handle_friends_postback
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'CHALLENGE A FRIEND'
      @api = Api.new
      @api.find_or_create('users', user.id)
      quick_replies = @api.user.friends.map(&:full_name).first(3).push("Search friends?")
      message.typing_on
      say "👇", quick_replies: quick_replies
      message.typing_off
      next_command :handle_challenge
    when 'FIND FRIENDS'
      message.typing_on
      say "You can search for up to 5 at a time, adding em all in one fell swoop 😉"
      message.typing_off
      message.typing_on
      say "👇"
      next_command :handle_user_lookup
    end
  end

  def handle_try_again
    say "Ok, carry on with your life" and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'TRY AGAIN'
      message.typing_on
      say "Let's try that one more time..."
      message.typing_off
      next_command :handle_user_lookup
    when 'NO THANKS'
      message.typing_on
      say "Ok, carry on with your life"
      message.typing_off
      stop_thread
    end
  end

  def handle_user_lookup
    say "Ok, carry on with your life" and stop_thread and return if (message.quick_reply && message.quick_reply == "NO THANKS")
    @api = Api.new
    @api.find_or_create('users', user.id)
    @api.friend_lookup(message.text)
    quick_replies = @api.user_list.map(&:full_name)
    store_ids = []
    if @api.user_list.empty?
      say FRIEND_LOOKUP.sample, quick_replies: ["Try again", "No thanks"]
      next_command :handle_try_again
    else
      if quick_replies.length > 1
        quick_replies = quick_replies.each_slice(1).to_a.each_with_index do |user, index|
          user.push("#{@api.user_list[index].full_name} #{@api.user_list[index].id}")
          store_ids.push(@api.user_list[index].id)
        end
        quick_replies.unshift(["Add everyone", "EVERYONE #{store_ids}"])
      else
        quick_replies = quick_replies.each_slice(1).to_a.each_with_index do |user, index|
          user.push("#{@api.user_list[index].full_name} #{@api.user_list[index].id}")
        end
      end
      puts "Quick replies => #{quick_replies.inspect}"
      say "Tap on the name(s) below to send a friend request. Once they accept, you'll be able to challenge each other. Don't worry, I'll send you an update on the status of your friendship.", quick_replies: quick_replies
      next_command :handle_friend_request
    end
  end

  def handle_friend_request
    # say "Cold feet, huh? All good." and stop_thread and return if ( message.text.upcase != message.quick_reply.split(',')[0] && !message.quick_reply.split(' ')[0].is_a?(Integer) )
    case message.quick_reply.split(' ')[0]
    when 'EVERYONE'
      start = message.quick_reply.index('[')
      ids = eval(message.quick_reply[start..-1])
      say "#{ids.inspect}"
      # send_friend_request(ids)
      say "Great! I've sent a friend request to all your friends. Let's hope things work out, or else this was awkward...", quick_replies: ["Friends", "Select picks", "Status"]
      stop_thread
    else
      id = eval(message.quick_reply.split(' ')[-1])
      # send_friend_request(ids)
      say "#{id.inspect}"
      say "Great! I've sent a friend request to #{message.text}. Let's hope things work out, or else this was awkward...", quick_replies: ["Friends", "Select picks", "Status"]
      stop_thread
    end
  end

  def handle_friend_lookup
    message.typing_on
    say "Ok, type in the friend you're looking for 👇", quick_replies: ["Nevermind"]
    message.typing_off
    next_command :handle_confirm_friend
  end

  def handle_confirm_friend
    say "Are you sure they accepted your request? Type 'Add friends' to send a friend request 👍", quick_replies: ["Select picks", "Status"] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    # needs to search within friends only
    @api = Api.new
    @api.find_or_create('users', user.id)
    @api.friend_lookup(message.text)
    quick_replies = @api.user_list.map(&:full_name).first(2).push("Nope")
    friend = message.text
    say "Find em?", quick_replies: quick_replies
    next_command :handle_challenge
  end

  def handle_challenge
    say "#{message.text} huh? All good." and stop_thread and return if (message.text.upcase != message.quick_reply)
    case message.quick_reply
    when 'SEARCH FRIENDS?'
      handle_friend_lookup
    when 'NOPE'
      handle_friend_lookup
    else
      friend = message.text
      say "What kind of challenge would you like to send #{friend.split(' ')[0]}?", quick_replies: ["Highest streak", "Most wins"]
      next_command :handle_confirm_challenge
    end
  end

  def handle_confirm_challenge
    case message.quick_reply
    when 'HIGHEST STREAK'
      say "Here are the rules for highest streak..."
      stop_thread
    when 'MOST WINS'
      say "Here are the rules for most wins..."
      stop_thread
    end
  end
end
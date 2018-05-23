module Commands
  def handle_lifeline
    @api = Api.new
    @api.fetch_user(user.id)
    case message.quick_reply
    when 'Yes Lifeline'
      if @api.user.current_streak > 0 || (@api.user.previous_streak == 0 && @api.user.current_streak == 0)
        short_wait(:message)
        say "Hold up #{@api.user.first_name}, I don't think you meant to reset yourself back to zero from a streak of #{@api.user.current_streak}, did you? That's crazy talk."
        short_wait(:message)
        say "Emma's got you. Let's get back to it 👇", quick_replies: ["Select picks", "Status"]
        stop_thread
      else
        if @api.user.data.sweep_coins < 30
          say "You do not have enough Sweepcoins for a lifeline. Keep playing to earn more, or invite some friends!", quick_replies: ["Select picks", "Status", "Invite Friends"]
          stop_thread
        else
          use_lifeline
          @api.fetch_user(user.id)
          short_wait(:message)
          say "Sweet! Let me go update that real quick..."
          short_wait(:message)
          say "Great! Your streak has been set back to #{@api.user.current_streak} 🔥\n\nYour new Sweepcoin balance is #{@api.user.data.sweep_coins} 👌", quick_replies: ["Select picks", "Status"]
          stop_thread
        end
      end
    when 'No Lifeline'
      short_wait(:message)
      say "Ok, I'll hold off for now 👌", quick_replies: ["Select picks", "Status"]
      stop_thread
    else
      redirect(:lifeline)
      stop_thread
    end
  end

  def handle_not_enough_for_lifeline
    case message.quick_reply
    when 'INVITE FRIENDS'
      @api = Api.new
      @api.fetch_user(user.id)
      $tracker.track(@api.user.id, 'User Intended Referral', {'for' => 'Lifeline'})
      short_wait(:message)
      say INVITE_FRIENDS.sample
      medium_wait(:message)
      show_invite
      stop_thread
    end
  end

  def handle_challenge_response
    payload = message.quick_reply.split(' ')[0...-1].join(' ') unless !message.quick_reply
    id = message.quick_reply.split(' ')[-1] unless !message.quick_reply
    case payload
    when 'ACCEPT CHALLENGE REQUEST'
      accept_challenge_action(id)
    when 'DECLINE CHALLENGE REQUEST'
      decline_challenge_action(id)
    else
      say "Tap below to act on any pending challenges you might have missed 👇", quick_replies: ["My challenges"]
      stop_thread
    end
  end

  def accept_challenge_action id
    @api = Api.new
    @api.fetch_user(user.id)
    @api.fetch_challenge(user.id, id)
    sleep 1
    if @api.user.data.pending_balance >= @api.challenge.wager.coins
      @api.update('challenges', id, { :accept => true }, user.id)
      short_wait(:message)
      say "Challenge accepted 👍"
      quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      short_wait(:message)
      #TODO make api call to populate random category gif
      show_media_with_button(user.id, 'challenges', 1261098830686834, quick_replies)
      stop_thread
    else
      say "You do not have enough Sweepcoins to accept this challenge 😤\n\nInvite some friends or respond with a new wager amount 👍", quick_replies: ["Invite friends", "Challenges"]
      @api.update('challenges', id, { :decline => true, :reason => :insufficient_funds }, user.id)
      stop_thread
    end
  end

  def decline_challenge_action id
    @api = Api.new
    @api.update('challenges', id, { :decline => true }, user.id)
    short_wait(:message)
    say "Challenge declined 👎"
    quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    short_wait(:message)
    #TODO make api call to populate random category gif
    show_media_with_button(user.id, 'challenges', 1261101310686586, quick_replies)
    stop_thread
  end

end
module Commands
  def handle_lifeline
    @api = Api.new
    @api.fetch_user(user.id)
    case message.quick_reply
    when 'Yes Lifeline'
      if @api.user.current_streak > 0 || (@api.user.previous_streak == 0 && @api.user.daily.high_streak == 0)
        short_wait(:message)
        say "I don't think you wanna do that #{@api.user.first_name}. That's crazy talk."
        short_wait(:message)
        say "Emma's got you. Let's get back to it 👇", quick_replies: ["Select picks", "Status"]
        user.session[:lifeline_streak] = nil
        stop_thread
      elsif @api.user.data.sweep_coins < 30
        say "You do not have enough Sweepcoins for a lifeline. Keep making picks and challenging/inviting your friends to earn more 💵", quick_replies: ["Select picks", "Status", "Invite Friends"]
        user.session[:lifeline_streak] = nil
        stop_thread
      else
        use_lifeline(user.session[:lifeline_streak])
        @api.fetch_user(user.id)
        short_wait(:message)
        say "Well played 👏 you're back to #{@api.user.current_streak} 🔥\n\nYour new Sweepcoin balance is #{@api.user.data.sweep_coins} 👌", quick_replies: ["Select picks", "Status"]
        stop_thread
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
    else
      say "👋"
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
    @api.update('challenges', id, { :accept => true }, user.id)
    sleep 2
    if @api.challenge_valid
      short_wait(:message)
      say "Challenge accepted 👍"
      quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      @api.fetch_media('challenge_accepted')
      short_wait(:message)
      show_media_with_button(user.id, 'challenges', @api.media.last(15).sample.attachment_id, quick_replies)
      stop_thread
    else
      short_wait(:message)
      say "Awe man...this challenge is no longer available 😕", quick_replies: ['Make picks', 'Status', 'Challenges']
      stop_thread
    end
  end

  def decline_challenge_action id
    @api = Api.new
    @api.update('challenges', id, { :decline => true }, user.id)
    sleep 2
    if @api.challenge_valid
      short_wait(:message)
      say "Challenge declined 👎"
      quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      @api.fetch_media('challenge_declined')
      short_wait(:message)
      show_media_with_button(user.id, 'challenges', @api.media.last(15).sample.attachment_id, quick_replies)
      stop_thread
    else
      short_wait(:message)
      say "This challenge is no longer available, so you're good 👍", quick_replies: ['Make picks', 'Status', 'Challenges']
      stop_thread
    end
  end

end
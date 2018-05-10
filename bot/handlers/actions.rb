module Commands
  def handle_lifeline
    @api = Api.new
    @api.fetch_user(user.id)
    case message.quick_reply
    when 'Yes Lifeline'
      if @api.user.current_streak > 0 || (@api.user.previous_streak == 0 && @api.user.current_streak == 0)
        message.typing_on
        say "Hold up #{@api.user.first_name}, I don't think you meant to reset yourself back to zero from a streak of #{@api.user.current_streak}, did you? That's crazy talk."
        sleep 1.5
        message.typing_on
        sleep 1.5
        say "Emma's got you. Tap the options below to get back to it 👇", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        if @api.user.data.sweep_coins < 30
          say "You do not have enough Sweepcoins for a lifeline. Keep playing to earn more, or invite some friends!", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"], ["Invite Friends", "Invite Friends"]]
          stop_thread
        else
          use_lifeline
          @api.fetch_user(user.id)
          message.typing_on
          say "Sweet! Let me go update that real quick..."
          sleep 1.5
          message.typing_on
          sleep 1.5
          say "Great! Your streak has been set back to #{@api.user.current_streak} 🔥"
          sleep 1.5
          message.typing_on
          sleep 2
          say "Your new Sweepcoin balance is #{@api.user.data.sweep_coins} 👌", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
          stop_thread
        end
      end
    when 'No Lifeline'
      message.typing_on
      say "Ok, I'll hold off for now 👌", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
      message.typing_off
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
      $tracker.track(@api.user.id, 'User Intended Referral')
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
      #TODO check if user has enough to accept
      @api = Api.new
      @api.fetch_user(user.id)
      @api.fetch_challenge(user.id, id)
      sleep 1
      if @api.user.data.pending_balance >= @api.challenge.wager.coins
        @api.update('challenges', id, { :accept => true }, user.id)
        text = "Challenge accepted 👍\n\nView your current/pending challenges by tapping My Challenges below 👇"
        quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
        url = "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}"
        show_button("My Challenges", text, quick_replies, url)
        stop_thread
      else
        say "You do not have enough Sweepcoins to accept this challenge 😤\n\nInvite some friends or respond with a new wager amount 👍", quick_replies: ["Invite friends", "Challenges"]
        @api.update('challenges', id, { :decline => true, :reason => :insufficient_funds }, user.id)
        stop_thread
      end
    when 'DECLINE CHALLENGE REQUEST'
      @api = Api.new
      @api.update('challenges', id, { :decline => true }, user.id)
      text = "Challenge declined 👎\n\nView your current/pending challenges by tapping My Challenges below 👇"
      quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      url = "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}"
      show_button("My Challenges", text, quick_replies, url)
      stop_thread
    else
      say "Tap below to act on any pending challenges you might have missed 👇", quick_replies: ["My challenges"]
      stop_thread
    end
  end

end
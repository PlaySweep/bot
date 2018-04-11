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
      say "Invite a friend"
      stop_thread
    when 'CHALLENGE A FRIEND'
      say "Challenge a friend"
      stop_thread
    end
  end

  def handle_challenge_response
    payload = message.quick_reply.split(' ')[0...-1].join(' ') unless !message.quick_reply
    id = message.quick_reply.split(' ')[-1] unless !message.quick_reply
    case payload
    when 'ACCEPT CHALLENGE REQUEST'
      @api = Api.new
      @api.update('challenges', id, { :accept => true }, user.id)
      say "Accepted!", quick_replies: ["Challenge a friend", "Select picks", "Status"]
      # send message to requestor
      stop_thread
    when 'DENY CHALLENGE REQUEST'
      @api = Api.new
      @api.update('challenges', id, { :accept => true }, user.id)
      say "Declined!", quick_replies: ["Challenge a friend", "Select picks", "Status"]
      # send message to requestor
      stop_thread
    else
      say "I don't see anything here to accept or deny, but while you're at it...challenge some friends!", quick_replies: ["Challenge a friend"]
      stop_thread
    end
  end

end
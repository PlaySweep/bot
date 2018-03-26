module Commands
  def handle_lifeline
    @api = Api.new
    @api.find_or_create('users', user.id)
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
        use_lifeline(user.id)
        @api.find_or_create('users', user.id)
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
    when 'No Lifeline'
      message.typing_on
      say "Ok, I'll hold off for now 👌", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
      message.typing_off
      stop_thread
    end
  end

  def handle_lifeline_for_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    case postback.quick_reply
    when 'Yes Lifeline'
      if @api.user.current_streak > 0 || (@api.user.previous_streak == 0 && @api.user.current_streak == 0)
        postback.typing_on
        say "Hold up #{@api.user.first_name}, I don't think you meant to reset yourself back to zero from a streak of #{@api.user.current_streak}, did you? That's crazy talk."
        sleep 1.5
        postback.typing_on
        sleep 1.5
        say "Emma's got you. Tap the options below to get back to it 👇", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        use_lifeline(user.id)
        @api.find_or_create('users', user.id)
        postback.typing_on
        say "Sweet! Let me go update that real quick..."
        sleep 1.5
        postback.typing_on
        sleep 1.5
        say "Great! Your streak has been set back to #{@api.user.current_streak} 🔥"
        sleep 1.5
        postback.typing_on
        sleep 2
        say "Your new Sweepcoin balance is #{@api.user.data.sweep_coins} 👌", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      end
    when 'No Lifeline'
      postback.typing_on
      say "Ok, I'll hold off for now 👌", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
      postback.typing_off
      stop_thread
    end
  end
end
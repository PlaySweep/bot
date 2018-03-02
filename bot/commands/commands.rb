module Commands
  # If the command is bound with reply_with specified,
  # you have to deal with user response to the last message and react on it.

  def start
    user = get_or_set_user["user"]
    text = "Welcome to Sweep #{user["first_name"]}!\n\nWe’re giving away $50 worth of Amazon gift cards every game day. Predict 4 games in a row and win your piece of the pie!"
    say text, quick_replies: [["How to play", "How to play"], ["Select picks", "Select picks"]]
    if postback.referral
      referrer_id = postback.referral.ref
      puts "Referrer Id: #{referrer_id}"
      referral_count = user["referral_data"]["referral_count"]
      if @new_user
        puts "New user being updated..."
        update_sender(postback.referral.ref) unless referrer_id.to_i == 0
      end
    end
    stop_thread
  end

  # def use_mulligan
  #   user = get_or_set_user["user"]
  #   message.typing_on
  #   case message.quick_reply
  #   when 'Use Mulligan Yes'
  #     # make a call to the api to decrement mulligan count by 1 and reset the current_streak to the previous_streak
  #     text = "Nice! Your streak is now back to 3!\n\nYou have 0 mulligans left. Remember, if you can find 3 of your friends to join you on Sweep we will send you another mulligan!"
  #     say text, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"], ["Earn mulligans", "Earn mulligans"]]
  #   when 'Use Mulligan No'
  #     text = "I like where your heads at #{user["first_name"]}, save those bail outs for later 👍\n\nGet back to it below 👇"
  #     say text, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"], ["Earn mulligans", "Earn mulligans"]]
  #   end
  #   stop_thread
  # end

  def reset
    user = get_or_set_user["user"]
    text = "Welcome back to the flow, #{user["first_name"]}! Get back on track with the options below 🙌"
    say text, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"], ["Earn mulligans", "Earn mulligans"]]
    stop_thread
  end

  def manage_updates
    message.typing_on
    case message.text
    when 'Status'
      get_status
      if (user.session[:upcoming].nil? || user.session[:upcoming].empty?) && (user.session[:in_progress].nil? || user.session[:in_progress].empty?) && (user.session[:current].nil? || user.session[:current].empty?) 
        status_text = "You have nothing in flight for the day! Get started below 👇"
        status_quick_replies = [["Select picks", "Select picks"]]
        stop_thread
      else
        user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins" unless user.session[:history].empty?
        user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = "" unless user.session[:history].empty?
        messages = ["Let's get to the important stuff..."]
        status_text = "#{messages.sample}.\n\nTap and scroll through the options below to get the latest updates on your picks 🙌"
        status_quick_replies = [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
      end
      say status_text, quick_replies: status_quick_replies
      next_command :status
    when 'Reminders'
      message.typing_off
      text = "We will remind you when you haven't made any picks for the week.\n\nTap below to update your preference ⏰"
      say text, quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"], ["Skip", "Reminders Skip"]]
      next_command :set_reminders
    when 'In-game'
      message.typing_off
      text = "We will send you live, in-game props throughout the week.\n\nTap below to update your preference ⏰"
      say text, quick_replies: [["On", "Props On"], ["Off", "Props Off"], ["Skip", "Props Skip"]]
      next_command :set_props
    when 'Game recaps'
      message.typing_off
      text = "We will send you recaps after your games finish with a quick update on your results.\n\nTap below to update your preference ⏰"
      say text, quick_replies: [["For every win", "Recaps Win"], ["For every loss", "Recaps Loss"], ["For a Sweep", "Recaps Sweep"], ["Skip", "Recaps Skip"]]
      next_command :set_recaps
    when "I'm done"
      message.typing_off
      text = "Tap the options below to check your game status or make some picks 🙌"
      say text, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"]]
      stop_thread
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def send_feedback
    user = get_or_set_user["user"]
    message.typing_on
    quick_replies = [["Select picks", "Select picks"], ["Status", "Status"], ["Earn mulligans", "Earn mulligans"]]
    if message.text != "Eh, nevermind"
      full_name = "#{user["name"]}"
      say "Thanks for the feedback! We'll reach out to you soon...", quick_replies: quick_replies
      [1566539433429514, 1827403637334265].each do |sweep_user_id|
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: sweep_user_id },
          message: {
            text: "Feedback from #{full_name}\n\n#{message.text}"
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      end
      stop_thread
    else
      say "Great! Tap below to get back in the action 🎬", quick_replies: quick_replies
      stop_thread
    end
  end

  def set_reminders
    message.typing_on
    case message.quick_reply
    when 'Status'
      get_status
      if (user.session[:upcoming].nil? || user.session[:upcoming].empty?) && (user.session[:in_progress].nil? || user.session[:in_progress].empty?) && (user.session[:current].nil? || user.session[:current].empty?) 
        status_text = "You have nothing in flight for the day! Get started below 👇"
        status_quick_replies = [["Select picks", "Select picks"]]
        stop_thread
      else
        user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins" unless user.session[:history].empty?
        user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = "" unless user.session[:history].empty?
        messages = ["Let's get to the important stuff..."]
        status_text = "#{messages.sample}.\n\nTap and scroll through the options below to get the latest updates on your picks 🙌"
        status_quick_replies = [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
      end
      say status_text, quick_replies: status_quick_replies
      next_command :status
    when 'Reminders On'
      set_notification_settings(:reminders, true)
      text = "We will notify you before the games start..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    when 'Reminders Off'
      set_notification_settings(:reminders, false)
      text = "We will stop notifying you before the games start..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    when 'Reminders Skip'
      text = "Manage your notifications or get started making your picks below 👇"
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def set_props
    message.typing_on
    case message.quick_reply
    when 'Status'
      get_status
      if (user.session[:upcoming].nil? || user.session[:upcoming].empty?) && (user.session[:in_progress].nil? || user.session[:in_progress].empty?) && (user.session[:current].nil? || user.session[:current].empty?) 
        status_text = "You have nothing in flight for the day! Get started below 👇"
        status_quick_replies = [["Select picks", "Select picks"]]
        stop_thread
      else
        user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins" unless user.session[:history].empty?
        user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = "" unless user.session[:history].empty?
        messages = ["Let's get to the important stuff..."]
        status_text = "#{messages.sample}.\n\nTap and scroll through the options below to get the latest updates on your picks 🙌"
        status_quick_replies = [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
      end
      say status_text, quick_replies: status_quick_replies
      next_command :status
    when 'Props On'
      set_notification_settings(:props, true)
      text = "We will notify you when prop bets become available..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    when 'Props Off'
      set_notification_settings(:props, false)
      text = "We will stop notifying you when prop bets become available..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    when 'Props Skip'
      text = "Manage your notifications or get started making your picks below 👇"
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def set_recaps
    message.typing_on
    case message.quick_reply
    when 'Status'
      get_status
      if (user.session[:upcoming].nil? || user.session[:upcoming].empty?) && (user.session[:in_progress].nil? || user.session[:in_progress].empty?) && (user.session[:current].nil? || user.session[:current].empty?) 
        status_text = "You have nothing in flight for the day! Get started below 👇"
        status_quick_replies = [["Select picks", "Select picks"]]
        stop_thread
      else
        user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins" unless user.session[:history].empty?
        user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = "" unless user.session[:history].empty?
        messages = ["Let's get to the important stuff..."]
        status_text = "#{messages.sample}.\n\nTap and scroll through the options below to get the latest updates on your picks 🙌"
        status_quick_replies = [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
      end
      say status_text, quick_replies: status_quick_replies
      next_command :status
    when 'Recaps Win'
      text = "Would you like to be notified for every win?"
      say text, quick_replies: [["Yes", "Wins Yes"], ["No", "Wins No"]]
      next_command :set_recap_wins
    when 'Recaps Loss'
      text = "Would you like to be notified for every loss?"
      say text, quick_replies: [["Yes", "Losses Yes"], ["No", "Losses No"]]
      next_command :set_recap_losses
    when 'Recaps Sweep'
      text = "Would you like to be notified when you hit a Sweep?"
      say text, quick_replies: [["Yes", "Sweep Yes"], ["No", "Sweep No"]]
      next_command :set_recap_sweep
    when 'Recaps Skip'
      text = "Manage your notifications or get started making your picks below 👇"
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def set_recap_wins
    message.typing_on
    case message.quick_reply
    when 'Wins Yes'
      set_notification_settings(:recap_all, true)
      text = "We will notify you for every win..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    when 'Wins No'
      set_notification_settings(:recap_all, false)
      text = "We will stop notifying you for every win..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def set_recap_losses
    message.typing_on
    case message.quick_reply
    when 'Losses Yes'
      set_notification_settings(:recap_loss, true)
      text = "We will notify you for every loss..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    when 'Losses No'
      set_notification_settings(:recap_loss, false)
      text = "We will stop notifying you for every loss..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def set_recap_sweep
    message.typing_on
    case message.quick_reply
    when 'Sweep Yes'
      set_notification_settings(:recap_sweep, true)
      text = "We will notify you when you hit a Sweep..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    when 'Sweep No'
      set_notification_settings(:recap_sweep, false)
      text = "We will stop notifying you when you hit a Sweep..."
      say text, quick_replies: ["Manage updates", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def help
    user = get_or_set_user["user"]
    text = "We get it, #{user["first_name"]}...you've probably got some questions.\n\nWe are just getting started, and we know getting used to all this bot stuff can take some time at first (#botworldproblems 🙄)..."
    call_to_action = "While we work to find some better solutions, we would love for you to hit us up with whatever is on your mind by direct messaging Ben Sweep on Facebook Messenger.\n\nIn the meantime, get back on track by tapping on those little bubbles below 👌"
    say text
    sleep 8
    say call_to_action, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"], ["Earn mulligans", "Earn mulligans"]]
    stop_thread
  end

  def select_picks
    text = "Choose from the sports below 👇"
    say text, quick_replies: [['NBA', 'NBA'], ['NCAAB', 'NCAAB'], ['NHL', 'NHL']]
    stop_thread
  end

  def more_picks
    text = "In return for getting one of your friends to play Sweep with you, we will unlock another chance for you to hit your own Sweep!"
    say text, quick_replies: [["Unlock game", "Unlock game"], ["Update picks", "Select picks"]]
    stop_thread
  end

  def more_action
    user = get_or_set_user["user"]
    text = "We'll have more action for you soon #{user["first_name"]}! Stay tuned"
    say text, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"], ["Earn mulligans", "Earn mulligans"]]
    stop_thread
  end

  # def in_game
  #   text = "It doesn't look like we have any live plays for you yet 😕\n\nBut make sure you have your preferences updated in order to receive our in-game notifications"
  #   say text, quick_replies: [["Status", "Status"], ["Manage updates", "Manage updates"], ["Make more picks", "Select picks"]]
  #   stop_thread
  # end

  # def games
  #   user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins" unless user.session[:history].nil?
  #   user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = "" unless user.session[:history].nil?
  #   if user.session[:upcoming].nil? && user.session[:current].nil? && user.session[:current].nil?
  #     text = "You have nothing in flight for the day! Get started below 👇"
  #     quick_replies = ["Select picks"]
  #     stop_thread
  #   else
  #     text = "You have #{user.session[:history]["current_streak"]} #{wins} in a row #{emoji}\n\nTap the options below to check your game status or find out ways to increase your chances of winning 🙌"
  #     quick_replies = [["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
  #   end
  #   say text, quick_replies: quick_replies
  #   next_command :status
  # end

  def status
    get_status
    message.typing_on
    case message.quick_reply
    when 'Status'
      if (user.session[:upcoming].nil? || user.session[:upcoming].empty?) && (user.session[:in_progress].nil? || user.session[:in_progress].empty?) && (user.session[:current].nil? || user.session[:current].empty?) 
        status_text = "You have nothing in flight for the day! Get started below 👇"
        status_quick_replies = [["Select picks", "Select picks"]]
        stop_thread
      else
        user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins" unless user.session[:history].empty?
        user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = "" unless user.session[:history].empty?
        messages = ["Let's get to the important stuff..."]
        status_text = "#{messages.sample}.\n\nTap and scroll through the options below to get the latest updates on your picks 🙌"
        status_quick_replies = [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
      end
      say status_text, quick_replies: status_quick_replies
      next_command :status
    when 'Manage updates'
      text = "Tap the options below to manage your preferences 👇"
      say text, quick_replies: ["Reminders", "In-game", "Game recaps", ["I'm done", 'Status']]
      next_command :manage_updates
    when 'Select picks'
      text = "Choose from the sports below 👇"
      say text, quick_replies: [['NBA', 'NBA'], ['NCAAB', 'NCAAB'], ['NHL', 'NHL']]
      stop_thread
    when 'NCAAB'
      show_button_template('NCAAB')
      stop_thread
    when 'NBA'
      show_button_template('NBA')
      stop_thread
    when 'NHL'
      show_button_template('NHL')
      stop_thread
    when 'Wins'
      user.session[:history]["current_streak"] > 0 ? messages = ["Look at you over there with a streak of #{user.session[:history]["current_streak"]} 👏"] : messages = ["You have a current streak of #{user.session[:history]["current_streak"]}."]  
      text = "#{messages.sample}\n\nTake a look at our other options below for more details on upcoming, in-progress, or completed picks 👍"
      say text, quick_replies: [["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
      next_command :status
    when 'Earn mulligans'
      show_invite
      stop_thread
    when 'Invite friends'
      show_invite
      stop_thread
    when 'Up next'
      if user.session[:upcoming].nil? || user.session[:upcoming].empty?
        say "You have no games coming up...", quick_replies: [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      else
        # next_up = user.session[:upcoming].first
        # symbol = next_up["spread"] > 0 ? "+" : ""
        # spread_text = next_up["spread"] > 0 ? "underdogs" : "favorites"
        teams = ""
        upcoming = user.session[:upcoming]
        upcoming.each_with_index do |team, index|
          teams.concat("👉 #{team["selection"]} vs. #{team["opponent"]}\n")
        end
        text = "#{teams}"
        say text, quick_replies: [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      end
    when 'Live'
      if user.session[:in_progress].nil? || user.session[:in_progress].empty?
        say "You have no games in progress...", quick_replies: [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      else
        teams = ""
        in_progress = user.session[:in_progress]
        in_progress.each_with_index do |team, index|
          # symbol = team["spread"] > 0 ? "+" : ""
          teams.concat("#{team["team_abbrev"]}") and break if in_progress.length == 1
          teams.concat("#{in_progress[0]["team_abbrev"]} and #{in_progress[1]["team_abbrev"]}") and break if in_progress.length == 2
          teams.concat("and #{team["team_abbrev"]}") and break if index == in_progress.length - 1
          teams.concat("#{team["team_abbrev"]}, ")
        end
        text = "The #{teams} are in progress now..."
        say text, quick_replies: [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      end
    when 'Completed'
      if user.session[:current].nil? || user.session[:current].empty?
        say "You have nothing completed for today...", quick_replies: [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Select Picks", "Select picks"]]
        next_command :status
      else
        teams = ""
        user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins"
        user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = ""
        completed = user.session[:current]
        completed.each_with_index do |team, index|
          team["result"] == "W" ? result = "👍" : result = "👎"
          # symbol = team["spread"] > 0 ? "+" : ""
          teams.concat("#{result} #{team["team_abbrev"]}\n")
        end
        text = "Today's record 👇\n\n#{teams}"
        say text, quick_replies: [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Select Picks", "Select picks"]]
        next_command :status
      end
    else
      message.typing_off
      say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
      stop_thread
    end
  end

  def how_to_play
    message.typing_on
    case message.text
    when "How to play"
      message.typing_off
      text = "✅ You will have at least one game to choose from each day.\n\n✅ You can select as many or as few games as you want, completely free.\n\n✅ Getting 4 wins in a row is considered a Sweep.\n\nTap below to get started making your picks 👇"
      say text, quick_replies: ["Select picks"]
      stop_thread
    # when "What about prizes?"
    #   message.typing_off
    #   text = "We offer a $50 (Amazon) prize pool every day a game is played.\n\n✅ Take home the entire prize pool if you are the only one to hit a Sweep.\n\n✅ Share the prize pool with others if there are more winners.\n\n✅ The prize pool will rollover if no one hits a Sweep.\n\nNow get started by tapping below! 😁"
    #   say text, quick_replies: ["Select picks", "Manage updates"]
    #   stop_thread
    end
  end
end

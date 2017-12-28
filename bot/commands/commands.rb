module Commands
  # If the command is bound with reply_with specified,
  # you have to deal with user response to the last message and react on it.
  def start
    user = get_or_set_user["user"]
    text = "Welcome to Sweep #{user["first_name"]}!\n\nPick 4 wins in a row for your chance at a $50 gift card from Amazon."
    say text, quick_replies: ["How to play", "Select picks", "Notifications"]
    stop_thread
  end

  def notifications
    message.typing_on
    case message.text
    when 'Reminders'
      message.typing_off
      text = "We will remind you when you haven't made any picks for the week.\n\nTap below to update your preference ⏰"
      say text, quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"], ["Skip", "Reminders Skip"]]
      next_command :set_reminders
    when 'Props'
      message.typing_off
      text = "We will send you live, in-game props throughout the week.\n\nTap below to update your preference ⏰"
      say text, quick_replies: [["On", "Props On"], ["Off", "Props Off"], ["Skip", "Props Skip"]]
      next_command :set_props
    when 'Game recaps'
      message.typing_off
      text = "We will send you recaps after your games finish with a quick update on your results.\n\nTap below to update your preference ⏰"
      say text, quick_replies: [["For every win", "Recaps Win"], ["For every loss", "Recaps Loss"], ["For a Sweep", "Recaps Sweep"], ["Skip", "Recaps Skip"]]
      next_command :set_recaps
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def set_reminders
    message.typing_on
    case message.quick_reply
    when 'Reminders On'
      set_notification_settings(:reminders, true)
      text = "We will notify you before the games start..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    when 'Reminders Off'
      set_notification_settings(:reminders, false)
      text = "We will stop notifying you before the games start..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    when 'Reminders Skip'
      text = "Manage your notifications or get started making your picks below 👇"
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def set_props
    message.typing_on
    case message.quick_reply
    when 'Props On'
      set_notification_settings(:props, true)
      text = "We will notify you when prop bets become available..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    when 'Props Off'
      set_notification_settings(:props, false)
      text = "We will stop notifying you when prop bets become available..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    when 'Props Skip'
      text = "Manage your notifications or get started making your picks below 👇"
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def set_recaps
    message.typing_on
    case message.quick_reply
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
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def set_recap_wins
    message.typing_on
    case message.quick_reply
    when 'Wins Yes'
      set_notification_settings(:recap_all, true)
      text = "We will notify you for every win..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    when 'Wins No'
      set_notification_settings(:recap_all, false)
      text = "We will stop notifying you for every win..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def set_recap_losses
    message.typing_on
    case message.quick_reply
    when 'Losses Yes'
      set_notification_settings(:recap_loss, true)
      text = "We will notify you for every loss..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    when 'Losses No'
      set_notification_settings(:recap_loss, false)
      text = "We will stop notifying you for every loss..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def set_recap_sweep
    message.typing_on
    case message.quick_reply
    when 'Sweep Yes'
      set_notification_settings(:recap_sweep, true)
      text = "We will notify you when you hit a Sweep..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    when 'Sweep No'
      set_notification_settings(:recap_sweep, false)
      text = "We will stop notifying you when you hit a Sweep..."
      say text, quick_replies: ["Notifications", "Select picks"]
      stop_thread
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def help
    text = "Here are some keywords to help you navigate our app👇\n\nStatus\nLeaderboard\nNotifications"
    say text, quick_replies: ["Status", "Select picks", "Friends"]
    stop_thread
  end

  def select_picks
    text = "Choose your sport..."
    say text, quick_replies: %w[NFL NCAAF NBA]
    stop_thread
  end

  def status
    get_status
    message.typing_on
    case message.quick_reply
    when 'Select picks'
      text = "Choose your sport..."
      say text, quick_replies: %w[NFL NCAAF NBA]
      stop_thread
    when 'Up next'
      if user.session[:upcoming].empty?
        say "You have no games coming up...", quick_replies: [["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      else
        next_up = user.session[:upcoming].first
        symbol = next_up["spread"] > 0 ? "+" : ""
        spread_text = next_up["spread"] > 0 ? "underdogs" : "favorites"
        teams = ""
        upcoming = user.session[:upcoming][1..-1]
        upcoming.each_with_index do |team, index|
          teams.concat("👉 #{team["team_abbrev"]} vs. #{team["opponent_abbrev"]}\n")
        end
        text = "You have the #{next_up["team_abbrev"]} against the #{next_up["opponent_abbrev"]} next at (#{symbol}#{next_up["spread"]}) point #{spread_text}\n\n#{teams}"
        say text, quick_replies: [["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      end
    when 'Live'
      if user.session[:in_progress].empty?
        say "You have no games in progress...", quick_replies: [["Up next (#{user.session[:upcoming].count})", "Up next"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      else
        teams = ""
        in_progress = user.session[:in_progress]
        in_progress.each_with_index do |team, index|
          teams.concat(team["team_abbrev"]) and break if in_progress.length == 1
          teams.concat("#{in_progress[0]["team_abbrev"]} and #{in_progress[1]["team_abbrev"]}") and break if in_progress.length == 2
          teams.concat("and #{team["team_abbrev"]}") and break if index == in_progress.length - 1
          teams.concat("#{team["team_abbrev"]}, ")
        end
        text = "The #{teams} are in progress now..."
        say text, quick_replies: [["Up next (#{user.session[:upcoming].count})", "Up next"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
        next_command :status
      end
    when 'Completed'
      if user.session[:completed].empty?
        say "You have nothing completed for today...", quick_replies: [["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Select Picks", "Select picks"]]
        next_command :status
      else
        teams = ""
        user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins"
        user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = ""
        completed = user.session[:completed]
        completed.each_with_index do |team, index|
          team["result"] == "W" ? result = "👍" : result = "👎"
          symbol = team["spread"] > 0 ? "+" : ""
          teams.concat("#{result} #{team["team_abbrev"]} covered (#{symbol}#{team["spread"]})\n")
        end
        text = "#{default}\n\nToday's record 👇\n\n#{teams}"
        say text, quick_replies: [["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Select Picks", "Select picks"]]
        next_command :status
      end
    else
      message.typing_off
      say "Sorry, didn't catch that 🤷\n\nGet back on track with the options below 👇", quick_replies: ["Status", "Select picks", "Friends"]
      stop_thread
    end
  end

  def how_to_play
    message.typing_on
    case message.text
    when "How to play"
      message.typing_off
      text = "✅ You will have at least one game to choose from each day.\n\n✅ You can select as many or as few games as you want, completely free.\n\n✅ Getting 4 wins in a row is considered a Sweep.\n\nTo learn more about how the prizes work, tap below 👇"
      say text, quick_replies: ["What about prizes?", "Select picks", "Notifications"]
      stop_thread
    when "What about prizes?"
      message.typing_off
      text = "We offer a $50 (Amazon) prize pool every day a game is played.\n\n✅ Take home the entire prize pool if you are the only one to hit a Sweep.\n\n✅ Share the prize pool with others if there are more winners.\n\n✅ The prize pool will rollover if no one hits a Sweep.\n\nNow get started by tapping below! 😁"
      say text, quick_replies: ["Select picks", "Notifications"]
      stop_thread
    end
  end
end

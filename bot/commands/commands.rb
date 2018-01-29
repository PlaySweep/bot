module Commands

  def start
    user = get_or_set_user["user"]
    welcome_message = "Welcome to Sweep #{user["first_name"]} 🎉"
    say welcome_message
    postback.typing_on
    sleep 1
    text = "Let's get right to it..."
    show_double_button_template text
    if postback.referral
      referrer_id = postback.referral.ref
      puts "Referrer Id: #{referrer_id}"
      if @new_user
        puts "New user being updated..."
        update_sender(postback.referral.ref) unless referrer_id.to_i == 0
      end
    end
    stop_thread
  end

  def reset
    user = get_or_set_user["user"]
    text = "Welcome back to the flow, #{user["first_name"]}! Get back on track with the options below 🙌"
    say text, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"]]
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

  def referrals
    user = get_or_set_user["user"]
    referral_count = user["referral_data"]["referral_count"]
    say "Referral count is #{referral_count}"
    stop_thread
  end

  def send_feedback
    user = get_or_set_user["user"]
    message.typing_on
    quick_replies = [["Select picks", "Select picks"], ["Status", "Status"]]
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
    say text, quick_replies: [['NFL', 'NFL'], ['NBA', 'NBA']]
    stop_thread
  end

  def more_picks
    text = "In return for getting one of your friends to play Sweep with you, we will unlock another chance for you to hit your own Sweep!"
    say text, quick_replies: [["Unlock game", "Unlock game"], ["Update picks", "Select picks"]]
    stop_thread
  end

  def show_status_details
    if user.session[:history].nil? || user.session[:history].empty?
      streak_text = "You look new 👀\n\nGet started by making some picks!"
    else
      streak = user.session[:history]["current_streak"]
      if streak == 1
        wins = "win"
      else
        wins = "wins"
      end
      streak_text = "🔥 You have #{user.session[:history]["current_streak"]} #{wins} in a row."
    end
    if user.session[:upcoming].nil? || user.session[:upcoming].empty?
      upcoming_text = "You have no games coming up..."
    else
      next_up = user.session[:upcoming].first
      symbol = next_up["spread"] > 0 ? "+" : ""
      spread_text = next_up["spread"] > 0 ? "underdogs" : "favorites"
      upcoming_text = "👉 Next up is your pick of the #{next_up["team_abbrev"]} against the #{next_up["opponent_abbrev"]} at (#{symbol}#{next_up["spread"]}) point #{spread_text}."
    end
    say "#{streak_text}\n#{upcoming_text}"
  end

  def status_for_message
    get_status
    show_status_details
    text = "You can see more pick details by viewing your Dashboard"
    quick_replies = [{ content_type: 'text', title: "Select picks", payload: "Select picks"}]
    show_action_button(text, quick_replies)
    stop_thread
  end

  def status_for_postback
    get_status
    show_status_details
    text = "You can see more pick details by viewing your Dashboard"
    quick_replies = [{ content_type: 'text', title: "Select picks", payload: "Select picks"}]
    show_action_button(text, quick_replies)
    stop_thread
  end

  def how_to_play
    case postback.payload
    when "HOW TO PLAY"
      postback.typing_on
      text = "✅ You will have at least one game to choose from each day.\n\n✅ You can select as many or as few games as you want, completely free.\n\n✅ Getting 4 wins in a row is considered a Sweep.\n\nTap below to get started making your picks 👇"
      say text, quick_replies: ["Select picks"]
      postback.typing_off
      stop_thread
    end
  end
end

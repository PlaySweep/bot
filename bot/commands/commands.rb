module Commands
  KEYWORDS_FOR_STATUS = ['current', 'status', 'upcoming', 'progress', 'live', 'completed', 'finished', 'games']
  KEYWORDS_FOR_DASHBOARD = ['dashboard', 'referral', 'referrals', 'stats', 'record', 'history']
  KEYWORDS_FOR_FEEDBACK = ['feedback']
  KEYWORDS_FOR_UNAVAILABLE_SPORTS = ['baseball', 'soccer', 'boxing', 'mma', 'golf', 'tennis']

  def start
    $api.find_fb_user(user.id)
    $api.find_or_create('users', user.id)
    # user.session[:current_user] = $api.user # refactor to use session rather than call api for every request
    greeting = "Hey #{$api.user.first_name}, I'm Emma 👋..."
    postback.typing_on
    say greeting
    if postback.referral
      referrer_id = postback.referral.ref
      puts "Referrer Id: #{referrer_id}"
      update_sender(referrer_id) unless referrer_id.to_i == 0
    end
    message = "Every day, I curate a list of games for you to choose from. When you make a pick, I'll track your wins and losses.\n\nWhen you hit 4 games in a row, you win an Amazon gift card!"
    postback.typing_on
    sleep 2
    say message, quick_replies: [["I'm ready to play!", "I got this"], ["Try a walkthrough", "Walkthrough"]]
    stop_thread
  end

  def walkthrough
    $api.find_or_create('users', user.id)
    case message.quick_reply
    when 'Walkthrough'
      walkthrough = "Go ahead and practice selecting between the two teams below..."
      message.typing_on
      say walkthrough
      sleep 2
      message.typing_on
      sleep 1
      matchup = "The Philadelphia Eagles (+4.5) against the New England Patriots (-4.5)"
      say matchup, quick_replies: [["Eagles (+4.5)", "Eagles"], ["Patriots (-4.5)", "Patriots"]]
      next_command :walkthrough
    when 'Eagles'
      game = "Nice! You picked the Eagles (+4.5)...so what's that number mean? Thats called the spread.\n\nIn this example, the Eagles would need to win or not lose by more than 4.5 points for you to win this play."
      message.typing_on
      sleep 1
      say game, quick_replies: [["Let's get started!", "Ready"], ["Prizes?", "Prizes"]]
    when 'Patriots'
      game = "Nice! You picked the Patriots (-4.5)...so what's that number mean? Thats called the spread.\n\nIn this example, the Patriots would need to not just win, but win by more than 4.5 points for you to win this play."
      message.typing_on
      sleep 1
      say game, quick_replies: [["Let's get started!", "Ready"], ["Prizes?", "Prizes"]]
    when 'Prizes'
      prizes = "At the end of the day, I send out $25 worth of Amazon gift cards to those who have hit a Sweep.\n\nIf there is more than 1 winner for the day, they split the prize.\n\nIf I don't see any winners, the $25 prize will rollover to the following day (making the prize pool $50)!"
      message.typing_on
      sleep 2
      say prizes
      sleep 6
      message.typing_on
      sleep 3
      average = "On average, I send out roughly $8-12 worth to our winners on a daily basis, with the occasional rollover.\n\nBut the faster we grow, the higher the prize pool becomes!"
      say average, quick_replies: [["I'm ready!", "Ready"]]
    when 'Ready'
      intro = "Start making your picks #{$api.user.first_name}!"
      quick_replies = [["Select picks", "Select picks"]]
      message.typing_on
      say intro, quick_replies: quick_replies
      stop_thread
    end
  end

  def manage_updates
    $api.find_or_create('users', user.id)
    case message.text
    when 'Reminders'
      say "Reminder on or off?", quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"]]
      next_command :handle_notifications
    else
      status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
      dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
      feedback and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_FEEDBACK.include?(keyword) }
    end
  end

  def handle_notifications
    $api.find_or_create('users', user.id)
    case message.quick_reply
    when 'Reminders On'
      set_notification_settings(:reminders, true)
      say "We turned your reminders on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Reminders Off'
      set_notification_settings(:reminders, false)
      say "We won't bug you with reminders anymore", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    end
  end

  def dashboard
    $api.find_or_create('users', user.id)
    stats = "#{$api.user.stats.wins} wins and #{$api.user.stats.wins} losses\n"
    current_streak = "#{$api.user.current_streak} wins in a row\n"
    sweep_count = "#{$api.user.sweep_count} total sweeps\n"
    referrals = "#{$api.user.data.referral_count} referrals"
    text = stats + current_streak + sweep_count + referrals
    say text, quick_replies: [["Select picks", "Select picks"]]
    stop_thread
  end

  def feedback
    $api.find_or_create('users', user.id)
    text = "Type your message below #{$api.user.first_name} and one of our guys will reach out to you soon 🤝"
    quick_replies = [["Eh, nevermind", "Eh, nevermind"]]
    say text, quick_replies: quick_replies
    next_command :send_feedback
  end

  def send_feedback
    $api.find_or_create('users', user.id)
    quick_replies = [["Select picks", "Select picks"], ["Status", "Status"]]
    message.typing_on
    if message.text != "Eh, nevermind"
      full_name = "#{$api.user.full_name}"
      say "Thanks for the feedback! We'll reach out to you soon...", quick_replies: quick_replies
      # [1566539433429514, 1827403637334265].each do |sweep_user_id|
      #   message_options = {
      #     messaging_type: "UPDATE",
      #     recipient: { id: sweep_user_id },
      #     message: {
      #       text: "Feedback from #{full_name}\n\n#{message.text}"
      #     }
      #   }
      #   Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      # end
      stop_thread
    else
      say "Great! Tap below to get back in the action 🎬", quick_replies: quick_replies
      stop_thread
    end
  end

  def set_reminders
    $api.find_or_create('users', user.id)   
  end

  def set_props
    $api.find_or_create('users', user.id)   
  end

  def set_recaps
    $api.find_or_create('users', user.id)   
  end

  def set_recap_wins
    $api.find_or_create('users', user.id)  
  end

  def set_recap_losses
    $api.find_or_create('users', user.id)   
  end

  def set_recap_sweep
    $api.find_or_create('users', user.id)   
  end

  def unavailable_sports
    $api.find_or_create('users', user.id)
    quick_replies = [["Select picks", "Select picks"], ["Status", "Status"]]
    say "We don't have #{message.text} yet, but we will let you know when we add more sports...", quick_replies: quick_replies
  end

  def show_sports
    $api.find_or_create('users', user.id)
    case message.text
    when "NFL"
      handle_pick
    when "NBA"
      handle_pick
    else
      unavailable_sports and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_UNAVAILABLE_SPORTS.include?(keyword) }
      stop_thread
    end
  end

  def skip
    $api.find_or_create('users', user.id)
    sport, matchup_id = message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    # make api call to set skipped flag on matchup
    $api.update('matchups', matchup_id, { :matchup => {:skipped => true, :skipped_by => $api.user.id.to_i} })
    $api.all('matchups', sport: sport)
    if $api.matchups.empty?
      say "No new picks yet for the #{sport.upcase}. We'll let you know when we add more games...", quick_replies: [["Other sports", "Select picks"]]
      stop_thread
    else
      status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
      dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
      text = "Next up is the #{$api.matchups.first.away_side.name} vs the #{$api.matchups.first.home_side.name}"
      say text, quick_replies: [["#{$api.matchups.first.away_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.away_side.id}"], ["#{$api.matchups.first.home_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.home_side.id}"], ['Skip', "Skip #{$api.matchups.first.sport} #{$api.matchups.first.id}"]]
      next_command :handle_pick
    end
  end

  def handle_pick
    $api.find_or_create('users', user.id)
    sport, matchup_id, selected_id = message.quick_reply.split(' ')[0], message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    skip and return if message.quick_reply.split(' ')[0] == "Skip"
    if matchup_id && selected_id
      params = { :pick => {:user_id => $api.user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
      $api.create('picks', params)
      say "Nice pick with the #{$api.pick.selected}!" unless $api.pick.nil?
      message.typing_on
      sleep 2
      message.typing_off
      $api.all('matchups', sport: sport.downcase) unless sport.nil?
      if $api.matchups.empty?
        say "No more picks for the #{sport}. We'll let you know when we add more games...", quick_replies: [["Status", "Status"]]
        stop_thread
      else
        status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
        dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
        text = "Next up is the #{$api.matchups.first.away_side.name} vs the #{$api.matchups.first.home_side.name}"
        say text, quick_replies: [["#{$api.matchups.first.away_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.away_side.id}"], ["#{$api.matchups.first.home_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.home_side.id}"], ['Skip', "Skip #{$api.matchups.first.sport} #{$api.matchups.first.id}"]]
        next_command :handle_pick
      end
    else
      $api.all('matchups', sport: sport.downcase) unless sport.nil?
      if $api.matchups.empty?
        say "No new picks yet for the #{sport}. We'll let you know when we add more games...", quick_replies: [["Other sports", "Select picks"]]
        stop_thread
      else
        status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
        dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
        text = "Next up is the #{$api.matchups.first.away_side.name} vs the #{$api.matchups.first.home_side.name}"
        say text, quick_replies: [["#{$api.matchups.first.away_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.away_side.id}"], ["#{$api.matchups.first.home_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.home_side.id}"], ['Skip', "Skip #{$api.matchups.first.sport} #{$api.matchups.first.id}"]]
        next_command :handle_pick
      end
    end
  end

  # def upcoming_picks
  #   $api.find_or_create('users', user.id)
  #   $api.for_picks('upcoming')
  #   upcoming_text = ""
  #   $api.upcoming_picks.each do |pick, index|
  #     text = "#{pick.selected} "
  #     upcoming_text.concat(text)
  #   end
  #   quick_replies = [["Select picks", "Select picks"]]
  #   say "You don't have anything coming up at the moment", quick_replies: quick_replies and return if upcoming_text.empty?
  #   say upcoming_text, quick_replies: quick_replies
  #   stop_thread
  # end

  # def in_progress_picks
  #   $api.find_or_create('users', user.id)
  #   $api.for_picks('in_progress')
  #   in_progress_text = ""
  #   $api.in_progress_picks.each do |pick, index|
  #     text = "#{pick.selected} "
  #     in_progress_text.concat(text)
  #   end
  #   quick_replies = [["Select picks", "Select picks"]]
  #   say "You don't have anything in progress at the moment", quick_replies: quick_replies and return if in_progress_text.empty?
  #   say in_progress_text, quick_replies: quick_replies
  #   stop_thread
  # end

  def status
    $api.find_or_create('users', user.id)
    $api.for_picks('current')
    # call show_media($fb_api.attachment_id) to display image

    current_streak = "Streak of #{$api.user.current_streak}\n"
    # status_message = current_streak + next_up + last_4
    quick_replies = [["Select picks", "Select picks"]]
    say current_streak, quick_replies: quick_replies
    stop_thread
  end

  def how_to_play
    $api.find_or_create('users', user.id)
  end
end

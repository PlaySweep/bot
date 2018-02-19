module Commands
  KEYWORDS_FOR_STATUS = ['current', 'status', 'upcoming', 'progress', 'live', 'completed', 'finished', 'games']
  KEYWORDS_FOR_DASHBOARD = ['dashboard', 'referral', 'referrals', 'stats', 'record', 'history']
  KEYWORDS_FOR_FEEDBACK = ['feedback']

  def start
    $api.find_or_create('users', $api.fb_user.id)
    greeting = "Hey #{$api.fb_user.first_name}, my name is Emma 👋"
    say greeting
    if postback.referral
      referrer_id = postback.referral.ref
      puts "Referrer Id: #{referrer_id}"
      update_sender(referrer_id) unless referrer_id.to_i == 0
    end
    postback.typing_on
    sleep 2
    message = "You can ask me to show you things like current matchups, my picks, stats, whatever you can think of..."
    say message
    postback.typing_on
    sleep 2
    message = "Let's try a walkthrough to show you how I operate (beep boop bleep)"
    say message, quick_replies: [["Ok!", "Ok!"], ["Nah, I got this!", "I got this"]]
    stop_thread
  end

  def walkthrough
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    case message.quick_reply
    when 'Ok!'
      message = "I'm so flattered that you would press my buttons ☺️\n\nButtons are a quick and easy way to get what you want, that way you don't have to go typing things out."
      quick_replies = [["I think I got this", "Ready"], ["What else?", "What else?"]]
      say message, quick_replies: quick_replies
      next_command :walkthrough
    when 'I got this'
      message = "Who are we kidding, you're ready #{$api.fb_user.first_name}!\n\nIf you have any questions on what to do, I'll be right here waiting for you (yup, I just quoted Richard Marx)"
      quick_replies = [["Select picks", "Select picks"]]
      say message, quick_replies: quick_replies
      stop_thread
    when 'Ready'
      message = "Let's get started #{$api.fb_user.first_name}!"
      quick_replies = [["Select picks", "Select picks"]]
      say message, quick_replies: quick_replies
      stop_thread
    when 'What else?'
      message = "I also know a lot about sports, so you can ask me questions about what you think you should pick..."
      quick_replies = [["Select picks", "Select picks"]]
      say message, quick_replies: quick_replies
      stop_thread
    end
  end

  def manage_updates
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
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
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
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
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    stats = "#{$api.user.stats.wins} wins and #{$api.user.stats.wins} losses\n"
    current_streak = "#{$api.user.current_streak} wins in a row\n"
    sweep_count = "#{$api.user.sweep_count} total sweeps\n"
    referrals = "#{$api.user.data.referral_count} referrals"
    text = stats + current_streak + sweep_count + referrals
    say text, quick_replies: [["Select picks", "Select picks"]]
    stop_thread
  end

  def feedback
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    text = "Type your message below #{$api.fb_user.first_name} and one of our guys will reach out to you soon 🤝"
    quick_replies = [["Eh, nevermind", "Eh, nevermind"]]
    say text, quick_replies: quick_replies
    next_command :send_feedback
  end

  def send_feedback
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
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
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user   
  end

  def set_props
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user   
  end

  def set_recaps
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user   
  end

  def set_recap_wins
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user  
  end

  def set_recap_losses
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user   
  end

  def set_recap_sweep
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user   
  end

  def show_sports
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    case message.text
    when "NFL"
      handle_pick
    when "NBA"
      handle_pick
    else
      say "You done messed up boy, best make your picks or else...jk, but seriously", quick_replies: [["Alright", "Alright"]]
      stop_thread
    end
  end

  def skip
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
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
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    sport, matchup_id, selected_id = message.quick_reply.split(' ')[0], message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    skip and return if message.quick_reply.split(' ')[0] == "Skip"
    if matchup_id && selected_id
      params = { :pick => {:user_id => $api.user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
      $api.create('picks', params)
      say "Nice pick with the #{$api.pick.selected}!"
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

  def upcoming_picks
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    $api.for_picks('upcoming')
    upcoming_text = ""
    $api.upcoming_picks.each do |pick, index|
      text = "#{pick.selected} "
      upcoming_text.concat(text)
    end
    quick_replies = [["Select picks", "Select picks"]]
    say "You don't have anything coming up at the moment", quick_replies: quick_replies and return if upcoming_text.empty?
    say upcoming_text, quick_replies: quick_replies
    stop_thread
  end

  def in_progress_picks
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    $api.for_picks('in_progress')
    in_progress_text = ""
    $api.in_progress_picks.each do |pick, index|
      text = "#{pick.selected} "
      in_progress_text.concat(text)
    end
    quick_replies = [["Select picks", "Select picks"]]
    say "You don't have anything in progress at the moment", quick_replies: quick_replies and return if in_progress_text.empty?
    say in_progress_text, quick_replies: quick_replies
    stop_thread
  end

  def status
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    # show current streak info | very next game up | last 4 results
    next_up = ""
    last_4 = ""
    $api.for_picks('upcoming')
    $api.for_picks('completed')

    if $api.upcoming_picks.any?
      next_up = "Next up #{$api.upcoming_picks[0].selected} against #{$api.upcoming_picks[0].opponent}\n"
    else
      last_4 = "You have nothing completed yet."
    end

    if $api.completed_picks.any?
      $api.completed_picks.each { |pick| last_4.concat("#{pick.result} - #{pick.selected}\n") }
    else
      last_4 = "You have nothing completed yet."
    end

    current_streak = "Streak of #{$api.user.current_streak}\n"
    status_message = current_streak + next_up + last_4
    quick_replies = [["Select picks", "Select picks"]]
    say status_message, quick_replies: quick_replies
    stop_thread
  end

  def how_to_play
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user 
  end
end

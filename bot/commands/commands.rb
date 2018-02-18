module Commands

  def start
    $api.find_or_create('users', $api.fb_user.id)
    welcome_message = "Welcome to Sweep #{$api.fb_user.first_name} 🎉"
    say welcome_message
    postback.typing_on
    text = "Let's get right to it..."
    show_double_button_template text
    if postback.referral
      referrer_id = postback.referral.ref
      puts "Referrer Id: #{referrer_id}"
      update_sender(referrer_id) unless referrer_id.to_i == 0
    end
    stop_thread
  end

  def reset
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    text = "Welcome back to the flow, #{$api.user.first_name}! Get back on track with the options below 🙌"
    say text, quick_replies: [["Status", "Status"], ["Select picks", "Select picks"]]
    stop_thread
  end

  def manage_updates
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    case message.text
    when 'Reminders'
      say "Reminder on or off?", quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"]]
      next_command :handle_notifications
    end
  end

  def handle_notifications
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

  def referrals
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    user = get_or_set_user
    referral_count = $api.user.referral_data.referral_count
    say "Referral count is #{referral_count}"
    stop_thread
  end

  def send_feedback
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    message.typing_on
    quick_replies = [["Select picks", "Select picks"], ["Status", "Status"]]
    if message.text != "Eh, nevermind"
      full_name = "#{$api.user.name}"
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

  def select_picks
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    case message.text
    when "NFL"
      handle_pick
    when "NBA"
      handle_pick
    end
  end

  def handle_pick
    # need to handle unexpected responses within the thread
    sport, matchup_id, selected_id = message.quick_reply.split(' ')[0], message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2]
    if matchup_id && selected_id
      params = { :pick => {:user_id => $api.user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
      $api.create('picks', params)
      say "Nice pick with the #{$api.pick.selected}!"
      message.typing_on
      sleep 2
      message.typing_off
      $api.all('matchups', sport: sport.downcase)
      if $api.matchups.empty?
        say "No more picks for the #{sport}. We'll let you know when we add more games...", quick_replies: [["Status", "Status"]]
        stop_thread
      else
        text = "Next up is the #{$api.matchups.first.away_side.name} vs the #{$api.matchups.first.home_side.name}"
        say text, quick_replies: [["#{$api.matchups.first.away_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.away_side.id}"], ["#{$api.matchups.first.home_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.home_side.id}"], ['Skip', 'Skip']]
        next_command :handle_pick
      end
    else
      $api.all('matchups', sport: sport.downcase)
      if $api.matchups.empty?
        say "No new picks yet for the #{sport}. We'll let you know when we add more games...", quick_replies: [["Other sports", "Other sports"]]
        stop_thread
      else
        text = "Next up is the #{$api.matchups.first.away_side.name} vs the #{$api.matchups.first.home_side.name}"
        say text, quick_replies: [["#{$api.matchups.first.away_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.away_side.id}"], ["#{$api.matchups.first.home_side.abbreviation}", "#{$api.matchups.first.sport} #{$api.matchups.first.id} #{$api.matchups.first.home_side.id}"], ['Skip', 'Skip']]
        next_command :handle_pick
      end
    end
  end

  def status_for_message
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    get_status
    say "#{$api.upcoming_picks}\n#{$api.in_progress_picks}\n#{$api.completed_picks}"
  end

  def status_for_postback
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user
    get_status
    say "#{$api.upcoming_picks}\n#{$api.in_progress_picks}\n#{$api.completed_picks}"
  end

  def how_to_play
    $api.find_or_create('users', $api.fb_user.id) # unless $api.user 
  end
end

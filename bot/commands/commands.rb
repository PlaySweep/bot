module Commands
  KEYWORDS_FOR_STATUS = ['current', 'status', 'upcoming', 'progress', 'live', 'completed', 'finished', 'games']
  KEYWORDS_FOR_DASHBOARD = ['dashboard', 'referral', 'referrals', 'stats', 'record', 'history']
  KEYWORDS_FOR_UNAVAILABLE_SPORTS = ['baseball', 'soccer', 'boxing', 'mma', 'golf', 'tennis']

  STATUS_HOT = ["You are lit 🔥", "Nom nom 🍔", "You're ridin' hot 🤠", "We have lift off 🚀", "You're going off ⏰"]

  def start
    $api.find_fb_user(user.id)
    $api.find_or_create('users', user.id)
    postback.typing_on
    say "Hey #{$api.user.first_name}, I'm Emma! Your Sweep agent 👋", quick_replies: [ ["Hi, Emma!", "Welcome"] ]
    if postback.referral
      referrer_id = postback.referral.ref
      puts "Referrer Id: #{referrer_id}"
      update_sender(referrer_id) unless referrer_id.to_i == 0
    end
    stop_thread
  end

  def catch
    message.typing_on
    say "Ok 😉", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  end

  def emoji_response
    emojis = %w[👍 😉 😎]
    message.typing_on
    say emojis.sample
    stop_thread
  end

  def walkthrough
    $api.find_or_create('users', user.id)
    case message.quick_reply
    when 'Welcome'
      message.typing_on
      say "I may be a bunch of 0's and 1's, but I've got skills!"
      message.typing_on
      sleep 0.5
      say "For instance, every day I curate a list of sports for you to pick."
      message.typing_on
      sleep 0.5
      say "And when you hit 4 straight wins, I'll send you a digital Amazon gift card 💰", quick_replies: [["How much?", "How much"]]
      next_command :walkthrough
    when 'How much'
      message.typing_on
      say "$25 prize pool per day, that's how much. And the cash rolls over to the following day when nobody wins 🤑"
      message.typing_on
      sleep 0.5
      say "Just imagine all the extra guac we'll be able to add to our Chipotle bowls.", quick_replies: [["Get that guac 🥑", "Ready"]]
      next_command :walkthrough
    when 'Ready'
      intro = "Start making your picks #{$api.user.first_name}!"
      quick_replies = [["Select picks", "Select picks"]]
      message.typing_on
      say intro, quick_replies: quick_replies
      stop_thread
    else
      say "Oh trying to be sneaky huh? It's all good, I got you. Make your picks below!", quick_replies: [["NFL", "NFL"], ["NBA", "NBA"], ["NCAAB", "NCAAB"]]
      stop_thread
    end
  end

  def manage_updates
    $api.find_or_create('users', user.id)
    case message.text
    when 'Reminders'
      say "Reminder on or off?", quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"]]
      next_command :handle_notifications
    when 'Game recaps'
      say "Game recaps on or off?", quick_replies: [["On", "Recaps On"], ["Off", "Recaps Off"]]
      next_command :handle_notifications
    else
      status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
      dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
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
    when 'Recaps On'
      set_notification_settings(:recaps, true)
      say "We turned your recaps on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Recaps Off'
      set_notification_settings(:recaps, false)
      say "We won't bug you with recaps anymore", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    end
  end

  def dashboard
    # $api.find_or_create('users', user.id)
    # stats = "#{$api.user.stats.wins} wins and #{$api.user.stats.wins} losses\n"
    # current_streak = "#{$api.user.current_streak} wins in a row\n"
    # sweep_count = "#{$api.user.sweep_count} total sweeps\n"
    # referrals = "#{$api.user.data.referral_count} referrals"
    # text = stats + current_streak + sweep_count + referrals
    # say text, quick_replies: [["Select picks", "Select picks"]]
    stop_thread
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
    when "NCAAB"
      handle_pick
    else
      # redirect(message.text)
      stop_thread
    end
  end

  def redirect message

  end

  def skip
    $api.find_or_create('users', user.id)
    sport, matchup_id = message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    $api.update('matchups', matchup_id, { :matchup => {:skipped => true, :skipped_by => $api.user.id.to_i} })
    $api.all('matchups', sport: sport)
    if $api.matchups.empty?
      say "No more picks for the #{sport.upcase}. I'll let you know when I find more games.", quick_replies: [["More sports", "Select picks"], ["Status", "Status"]]
      stop_thread
    else
      status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
      dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
      matchup = $api.matchups.first
      away = $api.matchups.first.away_side
      home = $api.matchups.first.home_side
      quick_replies = [
        { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
        { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
        { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
      ]
      message.typing_on
      show_media($api.matchups.first.attachment_id, quick_replies)
      message.typing_off
      next_command :handle_pick
    end
  end

  def handle_pick
    $api.find_or_create('users', user.id)
    sport, matchup_id, selected_id = message.quick_reply.split(' ')[0], message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    # refactor to handle unexpected messages
    skip and return if message.quick_reply.split(' ')[0] == "Skip"
    $api.all('matchups', sport: sport.downcase) unless sport.nil?
    games = $api.matchups.count > 1 || $api.matchups.count == 0 ? "games" : "game"
    say "We have #{$api.matchups.count} #{sport} #{games} on deck..." unless (matchup_id && selected_id || $api.matchups.empty?)
    if matchup_id && selected_id
      params = { :pick => {:user_id => user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
      $api.create('picks', params)
      say "#{$api.pick.selected} (#{$api.pick.action}) ✅" unless $api.pick.nil?
      message.typing_on
      sleep 1
      message.typing_off
      $api.all('matchups', sport: sport.downcase) unless sport.nil?
      if $api.matchups.empty?
        say "No more picks for the #{sport}. I'll let you know when I find more games.", quick_replies: [["More sports", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
        dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
        matchup = $api.matchups.first
        away = $api.matchups.first.away_side
        home = $api.matchups.first.home_side
        quick_replies = [
          { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
          { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
          { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
        ]
        message.typing_on
        show_media($api.matchups.first.attachment_id, quick_replies)
        message.typing_off
        next_command :handle_pick
      end
    else
      $api.all('matchups', sport: sport.downcase) unless sport.nil?
      if $api.matchups.empty?
        say "No more picks for the #{sport}. I'll let you know when I find more games.", quick_replies: [["More sports", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
        dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
        matchup = $api.matchups.first
        away = $api.matchups.first.away_side
        home = $api.matchups.first.home_side
        quick_replies = [
          { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
          { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
          { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
        ]
        message.typing_on
        sleep 3
        show_media($api.matchups.first.attachment_id, quick_replies)
        message.typing_off
        next_command :handle_pick
      end
    end
  end

  def handle_sweepcoins
    message.typing_on
    sleep 1.5
    say "To start, I deposit 1 coin every day you make a pick...so stay active!"
    sleep 1
    message.typing_on
    sleep 2
    say "I'll also add 10 more for every referral you make and every Sweep you hit!", quick_replies: [["Select picks", "Select picks"], ["Invite friends", "Invite friends"]]
    stop_thread
  end

  def sweepcoins
    $api.find_or_create('users', user.id)
    $api.user.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
    if $api.user.sweep_coins >= 30
      options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of high balance initial responses
      $api.user.current_streak > 0 ? quick_replies = [["Earn Sweepcoins", "Earn Sweepcoins"], ["Eh, I'm good", "I'm good"]] : quick_replies = [["Use Sweepback", "Use Sweepback"], ["Earn Sweepcoins", "Earn Sweepcoins"], ["Eh, I'm good", "I'm good"]]
      message.typing_on
      say options.sample
      sleep 1
      message.typing_on
      sleep 1.5
      say "I currently see #{$api.user.sweep_coins} #{sweepcoins} in your wallet 🤑"
      sleep 1
      message.typing_on
      sleep 0.5
      say "What else can I help you with?", quick_replies: quick_replies
      stop_thread
    else
      options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
      message.typing_on
      say options.sample
      sleep 1
      message.typing_on
      sleep 1.5
      say "I currently see #{$api.user.sweep_coins} #{sweepcoins} in your wallet 🤑"
      sleep 1
      message.typing_on
      sleep 0.5
      say "To use a Sweepback on one of your picks, you'll need at least 30 sweep coins", quick_replies: [["Earn Sweepcoins", "Earn Sweepcoins"], ["Select picks", "Select picks"]]
      stop_thread
    end
  end

  def my_picks
    $api.find_or_create('users', user.id)
    if $api.user.images.any?
      if $api.user.data.status_changed
        set('status changed', user.id)
        message.typing_on
        say "Brb, fetching the rest of your picks ⏳"
        message.typing_on
        $api.for_picks('status')
        quick_replies = [
          { content_type: 'text', title: "Select picks", payload: "Select picks" },
          { content_type: 'text', title: "Status", payload: "Status" }
        ]
        show_media($api.user.images.for_status, quick_replies)
      else
        message.typing_on
        quick_replies = [
          { content_type: 'text', title: "Select picks", payload: "Select picks" },
          { content_type: 'text', title: "Status", payload: "Status" }
        ]
        show_media($api.user.images.for_status, quick_replies)
      end
    else
      set('status changed', user.id)
      message.typing_on
      say "Brb, fetching the rest of your picks ⏳"
      message.typing_on
      $api.for_picks('status')
      quick_replies = [
        { content_type: 'text', title: "Select picks", payload: "Select picks" },
        { content_type: 'text', title: "Status", payload: "Status" }
      ]
      show_media($api.user.images.for_status, quick_replies)
    end
    stop_thread
  end

  def handle_sweepback
    $api.find_or_create('users', user.id)
    case message.quick_reply
    when 'Yes Lifeline'
      if $api.user.current_streak > 0
        message.typing_on
        say "Hold up #{$api.user.first_name}, I don't think you meant to reset yourself back to zero from a streak of #{$api.user.current_streak}, did you? That's crazy talk."
        sleep 1.5
        message.typing_on
        sleep 1.5
        say "Emma's got you. Tap the options below to get back to it 👇", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        use_lifeline(user.id)
        message.typing_on
        say "Sweet! Let me go update that real quick..."
        sleep 1.5
        message.typing_on
        sleep 1.5
        say "Great! Your streak has been set back to #{$api.user.current_streak} 🔥"
        sleep 1.5
        message.typing_on
        sleep 2
        say "Your new sweep coin balance is #{$api.user.sweep_coins} 👌", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      end
    when 'No Lifeline'
      message.typing_on
      say "Ok, I'll hold off for now 👌", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
      message.typing_off
      stop_thread
    end
  end

  def status
    $api.find_or_create('users', user.id)
    message.typing_on
    quick_replies = [["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
    if $api.user.current_streak > 0
      say STATUS_HOT.sample
      sleep 0.5
      message.typing_on
      sleep 1.5
      say "Your current streak sits at #{$api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if !$api.user.data.status_touched # if hasnt been touched yet
        set('status touched', user.id)
        if $api.user.sweep_coins >= 30
          quick_replies = [["Use Sweepback", "Use Sweepback"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero..."
          sleep 0.5
          message.typing_on
          sleep 2
          say "But I have good news, you have #{$api.user.sweep_coins} Sweepcoins 🤑"
          sleep 0.5
          message.typing_on
          sleep 3
          say "Turn back the 🕗 to your previous streak of #{$api.user.previous_streak} by trading in 30 coins for a Sweepback", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = [["Earn Sweepcoins", "Earn Sweepcoins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero."
          sleep 0.5
          message.typing_on
          $api.user.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
          sleep 2
          say "You have #{$api.user.sweep_coins} #{sweepcoins}...not quite enough to buy a Sweepback (30 coins) yet 🙄"
          message.typing_on
          sleep 1.5
          say "Did you wanna check for anything else?", quick_replies: quick_replies
          stop_thread
        end
      else
        if $api.user.sweep_coins >= 30
          quick_replies = [["Use Sweepback", "Use Sweepback"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = [["Earn Sweepcoins", "Earn Sweepcoins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        end
      end
    end
    message.typing_off
    stop_thread
  end

  def status_for_postback
    $api.find_or_create('users', user.id)
    postback.typing_on
    quick_replies = [["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
    if $api.user.current_streak > 0
      say STATUS_HOT.sample
      sleep 0.5
      postback.typing_on
      sleep 1.5
      say "Your current streak sits at #{$api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if !$api.user.data.status_touched # if hasnt been touched yet
        set('status touched', user.id)
        if $api.user.sweep_coins >= 30
          quick_replies = [["Use Sweepback", "Use Sweepback"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero..."
          sleep 0.5
          postback.typing_on
          sleep 2
          say "But I have good news, you have #{$api.user.sweep_coins} Sweepcoins 🤑"
          sleep 0.5
          postback.typing_on
          sleep 3
          say "Turn back the 🕗 to your previous streak of #{$api.user.previous_streak} by trading in 30 coins for a Sweepback", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = [["Earn Sweepcoins", "Earn Sweepcoins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero."
          sleep 0.5
          postback.typing_on
          sleep 2
          say "You have #{$api.user.sweep_coins} Sweepcoins...not quite enough to buy a Sweepback (30 coins) yet 🙄"
          postback.typing_on
          sleep 1.5
          say "Did you wanna check for anything else?", quick_replies: quick_replies
          stop_thread
        end
      else
        if $api.user.sweep_coins >= 30
          quick_replies = [["Use Sweepback", "Use Sweepback"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = [["Earn Sweepcoins", "Earn Sweepcoins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        end
      end
    end
    postback.typing_off
    stop_thread
  end

  def how_to_play
    # $api.find_or_create('users', user.id)
  end
end

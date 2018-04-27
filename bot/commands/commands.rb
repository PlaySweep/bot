module Commands
  KEYWORDS_FOR_STATUS = ['current', 'status', 'upcoming', 'progress', 'live', 'completed', 'finished', 'games']
  KEYWORDS_FOR_DASHBOARD = ['dashboard', 'referral', 'referrals', 'stats', 'record', 'history']
  KEYWORDS_FOR_UNAVAILABLE_SPORTS = ['baseball', 'soccer', 'boxing', 'mma', 'golf', 'tennis']

  STATUS_HOT = ["You are lit 🔥", "Nom nom 🍔", "You're ridin' hot 🤠", "We have lift off 🚀", "You're going off ⏰"]

  def start
    begin
      @api = Api.new
      @api.find_fb_user(user.id)
      puts "Facebook user found => #{@api.fb_user}"
      @api.find_or_create('users', user.id)
      postback.typing_on
      say "Hey #{@api.user.first_name}, you finally found me!", quick_replies: [ ["Hi, Emma!", "Welcome"] ]
      if postback.referral
        referrer_id = postback.referral.ref
        puts "Referrer Id: #{referrer_id}"
        update_sender(user.id, referrer_id) unless referrer_id.to_i == 0
      end
      stop_thread
      rescue NoMethodError => e
        say "Hmm 🤔..."
        postback.typing_on
        sleep 1.5
        postback.typing_on
        say "So I just tried to reach out to Facebook for some of your info and they seem to be having some issues."
        postback.typing_on
        sleep 0.5
        postback.typing_on
        say "...I'm Emma btw 👋, I'll keep a look out and let you know when we can get started 🎉"
        # send alert message
        stop_thread
    end
  end

  def catch
    emojis = %w[😏 🤑 😇 👌 🤗 👍 😉 😎]
    message.typing_on
    say emojis.sample, quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  end

  def emoji_response
    emojis = %w[😏 🤑 😇 👌 🤗 👍 😉 😎]
    message.typing_on
    say emojis.sample
    stop_thread
  end

  def walkthrough
    @api = Api.new
    @api.find_or_create('users', user.id)
    stop_thread and return if message.quick_reply.nil?
    case message.quick_reply
    when 'Welcome'
      message.typing_on
      say "😊"
      sleep 0.5
      message.typing_on
      sleep 1
      say "As you now know, I'm Emma! Your personal Sweep agent and the future of sports gaming 🤖"
      sleep 1
      message.typing_on
      sleep 1.5
      say "Every day from here on out, I'll send you a curated list of games to pick from, for free!"
      sleep 1
      message.typing_on
      sleep 1.5
      say "And when you hit 4 wins in a row, I'll send you a digital Amazon gift card 💰", quick_replies: [["How much?", "How much"]]
      next_command :walkthrough
    when 'How much'
      message.typing_on
      say "At the end of the day, I send out $25 worth of Amazon gift cards to winners. If there's more than 1 winner, you'll split the prize 🤑"
      sleep 1.5
      message.typing_on
      sleep 2.5
      say "On average, I send out about $8-12 per Sweep...it's hard work, but I love it ❤️"
      sleep 1
      message.typing_on
      sleep 1
      say "Amazon Prime here we come!", quick_replies: [["Start Sweeping 🎉", "Select picks"]]
      stop_thread
    else
      say "Oh trying to be sneaky huh? It's all good, I got you. Make your picks below!", quick_replies: [["NBA", "NBA"], ['MLB', 'MLB'] ["NHL", "NHL"]]
      stop_thread
    end
  end

  def manage_updates
    @api = Api.new
    @api.find_or_create('users', user.id)
    case message.text
    when 'Reminders'
      say "Reminder on or off?", quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"]]
      next_command :handle_notifications
    when 'Game recaps'
      say "Game recaps on or off?", quick_replies: [["On", "Recaps On"], ["Off", "Recaps Off"]]
      next_command :handle_notifications
    when 'Off'
      say "Turn off all notifications?", quick_replies: [["Yes", "All Off Yes"], ["Off", "All Off No"]]
      next_command :handle_notifications
    when 'Stop'
      say "Turn off all notifications?", quick_replies: [["Yes", "All Off Yes"], ["Off", "All Off No"]]
      next_command :handle_notifications
    when 'Unsubscribe'
      say "Turn off all notifications?", quick_replies: [["Yes", "All Off Yes"], ["Off", "All Off No"]]
      next_command :handle_notifications
    when "I'm good"
      say "Ok 😊", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"], ["Sweepcoins", "Sweepcoins"]]
      stop_thread
    else
      status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
      dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
    end
  end

  def handle_notifications
    @api = Api.new
    @api.find_or_create('users', user.id)    
    case message.quick_reply
    when 'Reminders On'
      set_notification_settings(user.id, :new_games, true)
      set_notification_settings(user.id, :reminders, true)
      say "I turned your reminders on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Reminders Off'
      set_notification_settings(user.id, :new_games, false)
      set_notification_settings(user.id, :reminders, false)
      say "I won't bug you with reminders anymore", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Recaps On'
      set_notification_settings(user.id, :recaps, true)
      say "I turned your recaps on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Recaps Off'
      set_notification_settings(user.id, :recaps, false)
      say "I won't bug you with recaps anymore", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'All Off Yes'
      set_notification_settings(user.id, :reminders, false)
      set_notification_settings(user.id, :new_games, false)
      set_notification_settings(user.id, :recaps, false)
      say "Ok, I won't bug you with notifications anymore 👍", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'All Off No'
      say "Ok, I won't touch a thing 👍", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
      stop_thread
    end
  end

  def dashboard
    @api = Api.new
    @api.find_or_create('users', user.id)
    message.typing_on
    say "I am cookin' up something special here 👩‍🍳"
    sleep 0.5
    message.typing_on
    say "I'll be the first to let you know when it's ready for show and tell 😊"
    stop_thread
  end

  def unavailable_sports
    @api = Api.new
    @api.find_or_create('users', user.id)   
    quick_replies = [["Select picks", "Select picks"], ["Status", "Status"]]
    say "We don't have #{message.text} yet, but we will let you know when we add more sports...", quick_replies: quick_replies
  end

  def show_sports
    @api = Api.new
    @api.find_or_create('users', user.id)
    case message.quick_reply
    when "NBA"
      handle_pick
    when "MLB"
      handle_pick
    when "NHL"
      handle_pick
    else
      redirect(message.text)
      stop_thread
    end
  end

  def redirect msg
    @api = Api.new
    @api.find_or_create('users', user.id)
    # send data (msg) to get smarter
    message.typing_on
    say "Hmm 💭...I must have dozed off 😴", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  end

  def skip
    @api = Api.new
    @api.find_or_create('users', user.id)  
    sport, matchup_id = message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    @api.update('matchups', matchup_id, { :matchup => {:skipped_by => @api.user.id.to_i} })
    options = ["Skipped 👍", "You can always come back later and pick 🙌", "You got it 😉", "Okie dokie 👉"]
    message.typing_on
    sleep 0.5
    say options.sample
    sleep 0.5
    message.typing_on
    sleep 1
    @api.all('matchups', sport: sport) unless sport.nil?
    if (@api.matchups.nil? || @api.matchups.empty?)
      say "All finished. I'll let you know when I find more games.", quick_replies: [["More sports", "Select picks"], ["Status", "Status"]]
      stop_thread
    else
      status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
      dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
      matchup = @api.matchups.first
      away = matchup.away_side
      home = matchup.home_side
      quick_replies = [
        { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
        { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
        { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
      ]
      message.typing_on
      sleep 0.5
      say "Starting #{matchup.custom_time}\n#{matchup.display_time}"
      sleep 1.5
      message.typing_on
      show_media(matchup.attachment_id, quick_replies)
      message.typing_off
      next_command :handle_pick
    end
  end

  def handle_pick
    @api = Api.new
    @api.find_or_create('users', user.id)
    say "🤔 Not sure how to make picks?", quick_replies: [["How to play", "How to play"], ["Select picks", "Select picks"], ["Status", "Status"]] and stop_thread and return if (!message.quick_reply && message.text)
    sport, matchup_id, selected_id = message.quick_reply.split(' ')[0], message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    return if message.quick_reply.nil?
    skip and return if message.quick_reply.split(' ')[0] == "Skip"
    @api.all('matchups', sport: sport.downcase) unless sport.nil?
    games = @api.matchups && @api.matchups.count > 1 || @api.matchups && @api.matchups.count == 0 ? "games" : "game"
    say "We have #{@api.matchups.count} #{sport} #{games} available" unless (matchup_id && selected_id || (@api.matchups.nil? || @api.matchups.empty?))
    if matchup_id && selected_id
      params = { :pick => {:user_id => user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
      @api.create('picks', params)
      message.typing_on
      sleep 1
      say "#{@api.pick.selected} (#{@api.pick.action}) ✅" unless @api.pick.nil?
      message.typing_on
      sleep 1
      @api.all('matchups', sport: sport.downcase) unless sport.nil?
      if (@api.matchups.nil? || @api.matchups.empty?)
        say "All finished. I'll let you know when I find more games.", quick_replies: [["More sports", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
        dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
        matchup = @api.matchups.first
        away = matchup.away_side
        home = matchup.home_side
        quick_replies = [
          { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
          { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
          { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
        ]
        message.typing_on
        sleep 0.5
        say "Starting #{matchup.custom_time}\n#{matchup.display_time}"
        sleep 1.5
        message.typing_on
        show_media(matchup.attachment_id, quick_replies)
        next_command :handle_pick
      end
    else
      @api.all('matchups', sport: sport.downcase) unless sport.nil?
      if (@api.matchups.nil? || @api.matchups.empty?)
        say "All finished. I'll let you know when I find more games.", quick_replies: [["More sports", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
        dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
        matchup = @api.matchups.first
        away = matchup.away_side
        home = matchup.home_side
        quick_replies = [
          { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
          { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
          { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
        ]
        message.typing_on
        sleep 0.5
        say "Starting #{matchup.custom_time}\n#{matchup.display_time}"
        sleep 1.5
        message.typing_on
        show_media(matchup.attachment_id, quick_replies)
        next_command :handle_pick
      end
    end
  end

  def earn_coins
    message.typing_on
    sleep 1
    say "🌞 Daily pick = 1 coin"
    sleep 1
    message.typing_on
    sleep 1
    say "👯 Refer a friend = 10 coins"
    sleep 1
    message.typing_on
    sleep 1
    say "🎉 Hit a Sweep = 10 coins", quick_replies: [["Sweep store", "Sweep store"], ["Select picks", "Select picks"], ["🎉 Share", "🎉 Share"]]
    stop_thread
  end

  def sweep_store
    @api = Api.new
    @api.find_or_create('users', user.id)
    if @api.user.data.store_touched
      if @api.user.data.sweep_coins >= 30 && (@api.user.previous_streak > @api.user.current_streak)
        options = ["We are open 24/7 🏪", "Hold up, let me find the keys 🔑"]
        message.typing_on
        sleep 1.5
        say options.sample
        sleep 1
        message.typing_on
        sleep 1
        say "Use a lifeline to set your streak back to #{@api.user.previous_streak} for 30 Sweepcoins 🙏", quick_replies: [["Use lifeline", "Use lifeline"], ["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      elsif @api.user.data.sweep_coins < 30 && (@api.user.previous_streak > @api.user.current_streak)
        options = ["We are open 24/7 🏪", "Hold up, let me find the keys 🔑"]
        coins_needed = (30 - @api.user.data.sweep_coins)
        message.typing_on
        sleep 1.5
        say options.sample
        sleep 1
        message.typing_on
        sleep 1
        say "You only need #{coins_needed} more Sweepcoins to set your streak back to #{@api.user.previous_streak} 👌", quick_replies: [["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        options = ["We are open 24/7 🏪", "Hold up, let me find the keys 🔑"]
        message.typing_on
        sleep 1.5
        say options.sample
        sleep 1
        message.typing_on
        sleep 1
        say "A lifeline is worth 30 coins and will reset you back to your previous streak, keeping your Sweep dreams alive 🙏", quick_replies: [["Use lifeline", "Use lifeline"], ["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      end
    else
      set('store touched', user.id)
      message.typing_on
      sleep 1.5
      say "Welcome to the Sweep store!"
      sleep 1
      message.typing_on
      sleep 1
      say "We are a small shop right now, so all we offer are lifelines."
      sleep 1
      message.typing_on
      sleep 2
      say "A lifeline is worth 30 coins and will reset you back to your previous streak, keeping your Sweep dreams alive 🙏", quick_replies: [["Use lifeline", "Use lifeline"], ["Select picks", "Select picks"], ["Status", "Status"]]
      stop_thread
    end
  end

  def sweepcoins
    @api = Api.new
    @api.find_or_create('users', user.id)
    @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
    if @api.user.data.sweep_coins >= 30
      options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of high balance initial responses
      @api.user.current_streak > 0 ? quick_replies = [["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]] : quick_replies = [["Use lifeline", "Use lifeline"], ["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]]
      message.typing_on
      say options.sample
      sleep 1
      message.typing_on
      sleep 1.5
      say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
      sleep 1
      message.typing_on
      sleep 0.5
      say "What else can I help you with?", quick_replies: quick_replies
      stop_thread
    else
      if @api.user.previous_streak > @api.user.current_streak
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        message.typing_on
        say options.sample
        sleep 1
        message.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
        sleep 1
        message.typing_on
        sleep 0.5
        say "To use a lifeline and reset your streak back to #{@api.user.previous_streak}, you'll need at least 30 Sweepcoins", quick_replies: [["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      else
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        message.typing_on
        say options.sample
        sleep 1
        message.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑", quick_replies: [["Sweep store", "Sweep store"], ["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      end
    end
  end

  def sweepcoins_for_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
    if @api.user.data.sweep_coins >= 30
      options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of high balance initial responses
      @api.user.current_streak > 0 ? quick_replies = [["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]] : quick_replies = [["Use lifeline", "Use lifeline"], ["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]]
      postback.typing_on
      say options.sample
      sleep 1
      postback.typing_on
      sleep 1.5
      say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
      sleep 1
      postback.typing_on
      sleep 0.5
      say "What else can I help you with?", quick_replies: quick_replies
      stop_thread
    else
      if @api.user.previous_streak > @api.user.current_streak
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        postback.typing_on
        say options.sample
        sleep 1
        postback.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
        sleep 1
        postback.typing_on
        sleep 0.5
        say "To use a lifeline and reset your streak back to #{@api.user.previous_streak}, you'll need at least 30 Sweepcoins", quick_replies: [["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      else
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        postback.typing_on
        say options.sample
        sleep 1
        postback.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑", quick_replies: [["Sweep store", "Sweep store"], ["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      end
    end
  end

  def my_picks
    @api = Api.new
    @api.find_or_create('users', user.id)
    options = ["😏, I like where your heads at", "You got this ✊"]
    begin
    if @api.user.images.any?
      if @api.user.data.status_changed
        set('status changed', user.id)
        begin
          message.typing_on
          @api.for_picks('upcoming')
          return if @api.upcoming_picks.nil?
          next_up = @api.upcoming_picks.first
          if next_up
            if next_up.type == 'Game'
              say "I see here you've got the #{next_up.abbreviation} up next at #{next_up.action} against the #{next_up.opponent}..."
              sleep 1
              message.typing_on
              sleep 1.5
              say options.sample, quick_replies: [["Select picks", "Select picks"], ["Earn more coins", "Earn more coins"]]
              stop_thread
            else
              say "I see here you've got #{next_up.selected} to #{next_up.action}"
              stop_thread
            end
          else
            say "I don't see any upcoming games for you yet", quick_replies: [["Select picks", "Select picks"]]
            stop_thread
          end  
          # holding off for template design
          # say "Brb, fetching the rest of your picks ⏳"
          # message.typing_on
          # @api.for_picks('status')
          # quick_replies = [
          #   { content_type: 'text', title: "Select picks", payload: "Select picks" },
          #   { content_type: 'text', title: "Status", payload: "Status" }
          # ]
          # show_media(@api.user.images.for_status, quick_replies)
          stop_thread
        rescue Facebook::Messenger::FacebookError => e
          say "Whoops, I screwed up. Gimme a sec, I'll try again..."
          # send an alert message
          stop_thread
        end
      else
        message.typing_on
        @api.for_picks('upcoming')
        return if @api.upcoming_picks.nil?
        next_up = @api.upcoming_picks.first
        if next_up
          if next_up.type == 'Game'
            say "I see here you've got the #{next_up.abbreviation} up next at #{next_up.action} against the #{next_up.opponent}..."
            sleep 1
            message.typing_on
            sleep 1.5
            say options.sample, quick_replies: [["Select picks", "Select picks"], ["Earn more coins", "Earn more coins"]]
            stop_thread
          else
            say "I see here you've got #{next_up.selected} to #{next_up.action}"
            stop_thread
          end
        else
          say "I don't see any upcoming games for you yet", quick_replies: [["Select picks", "Select picks"]]
          stop_thread
        end  
        # holding off for template design
        # quick_replies = [
        #   { content_type: 'text', title: "Select picks", payload: "Select picks" },
        #   { content_type: 'text', title: "Status", payload: "Status" }
        # ]
        # show_media(@api.user.images.for_status, quick_replies)
        stop_thread
      end
    else
      set('status changed', user.id)
      begin
        message.typing_on
        @api.for_picks('upcoming')
        return if @api.upcoming_picks.nil?
        next_up = @api.upcoming_picks.first
        if next_up
          if next_up.type == 'Game'
            say "I see here you've got the #{next_up.abbreviation} up next at #{next_up.action} against the #{next_up.opponent}......"
            sleep 1
            message.typing_on
            sleep 1.5
            say options.sample, quick_replies: [["Select picks", "Select picks"], ["Earn more coins", "Earn more coins"]]
            stop_thread
          else
            say "I see here you've got #{next_up.selected} to #{next_up.action}"
            stop_thread
          end
        else
          say "I don't see any upcoming games for you yet", quick_replies: [["Select picks", "Select picks"]]
          stop_thread
        end  
        @api.for_picks('upcoming')
        return if @api.upcoming_picks.nil?
        next_up = @api.upcoming_picks.first
        if next_up
          if next_up.type == 'Game'
            say "I see here you've got the #{next_up.abbreviation} up next at #{next_up.action} against the #{next_up.opponent}..."
            sleep 1
            message.typing_on
            sleep 1.5
            say options.sample, quick_replies: [["Select picks", "Select picks"], ["Earn more coins", "Earn more coins"]]
            stop_thread
          else
            say "I see here you've got #{next_up.selected} to #{next_up.action}"
            stop_thread
          end
        else
          say "I don't see any upcoming games for you yet", quick_replies: [["Select picks", "Select picks"]]
          stop_thread
        end
        # holding off for template design
        # say "Brb, fetching the rest of your picks ⏳"
        # message.typing_on
        # @api.for_picks('status')
        # quick_replies = [
        #   { content_type: 'text', title: "Select picks", payload: "Select picks" },
        #   { content_type: 'text', title: "Status", payload: "Status" }
        # ]
        # show_media(@api.user.images.for_status, quick_replies)
        stop_thread
      rescue Facebook::Messenger::FacebookError => e
        say "Whoops, I screwed up. Gimme a sec, I'll try again..."
        # send an alert message
        stop_thread
      end
    end

    rescue Facebook::Messenger::FacebookError => e
      say "Whoops, I screwed up. Gimme a sec, I'll try again..."
      # send an alert message
      stop_thread
    end

  end

  def select_picks
    text = "Choose from the sports below 👇"
    say text, quick_replies: [['NBA', 'NBA'], ['MLB', 'MLB'], ['NHL', 'NHL']]
    stop_thread
  end

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
        if @api.user.data.sweep_coins < 30
          say "You do not have enough Sweepcoins for a lifeline. Keep playing to earn more, or invite some friends!", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"], ["Invite Friends", "Invite Friends"]]
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

  def status
    @api = Api.new
    @api.find_or_create('users', user.id)
    message.typing_on
    quick_replies = [["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
    if @api.user.current_streak > 0
      say STATUS_HOT.sample
      sleep 0.5
      message.typing_on
      sleep 1.5
      say "Your current streak sits at #{@api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if !@api.user.data.status_touched # if hasnt been touched yet
        set('status touched', user.id)
        if @api.user.data.sweep_coins >= 30
          quick_replies = [["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          if @api.user.previous_streak == @api.user.current_streak
            message.typing_on
            sleep 1.5
            say "You're currently at a streak of zero..."
            sleep 1
            message.typing_on
            sleep 1.5
            say "Did you wanna check for anything else?", quick_replies: quick_replies
            stop_thread
          elsif @api.user.previous_streak <= @api.user.current_streak
            message.typing_on
            sleep 1.5
            say "You're currently at a streak of zero..."
            sleep 1
            message.typing_on
            sleep 1.5
            say "Did you wanna check for anything else?", quick_replies: quick_replies
            stop_thread
          else
            quick_replies = [["Use lifeline", "Use lifeline"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
            sleep 0.5
            message.typing_on
            sleep 2
            say "But I have good news, you have #{@api.user.data.sweep_coins} Sweepcoins 🤑"
            sleep 0.5
            message.typing_on
            sleep 3
            say "Turn back the 🕗 to your previous streak of #{@api.user.previous_streak} by trading in 30 Sweepcoins for a lifeline", quick_replies: quick_replies
            stop_thread
          end
        else
          quick_replies = [["Earn more coins", "Earn more coins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          coins_needed = (30 - @api.user.data.sweep_coins)
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero."
          sleep 0.5
          message.typing_on
          @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
          sleep 2
          say "You only need #{coins_needed} more Sweepcoins to set your streak back to #{@api.user.previous_streak} 👌"
          message.typing_on
          sleep 1.5
          say "Did you wanna check for anything else?", quick_replies: quick_replies
          stop_thread
        end
      else
        if @api.user.data.sweep_coins >= 30
          quick_replies = [["Use lifeline", "Use lifeline"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = [["Earn coins", "Earn coins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        end
        stop_thread
      end
    end
    message.typing_off
    stop_thread
  end

  def status_for_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    postback.typing_on
    quick_replies = [["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
    if @api.user.current_streak > 0
      say STATUS_HOT.sample
      sleep 0.5
      postback.typing_on
      sleep 1.5
      say "Your current streak sits at #{@api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if !@api.user.data.status_touched # if hasnt been touched yet
        set('status touched', user.id)
        if @api.user.data.sweep_coins >= 30
          quick_replies = [["Use lifeline", "Use lifeline"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero..."
          sleep 0.5
          postback.typing_on
          sleep 2
          say "But I have good news, you have #{@api.user.data.sweep_coins} Sweepcoins 🤑"
          sleep 0.5
          postback.typing_on
          sleep 3
          say "Turn back the 🕗 to your previous streak of #{@api.user.previous_streak} by trading in 30 coins for a lifeline", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = [["Earn coins", "Earn coins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero."
          sleep 0.5
          postback.typing_on
          sleep 2
          say "You have #{@api.user.data.sweep_coins} Sweepcoins...not quite enough to buy a lifeline (30 coins) yet 🙄"
          postback.typing_on
          sleep 1.5
          say "Did you wanna check for anything else?", quick_replies: quick_replies
          stop_thread
        end
      else
        if @api.user.data.sweep_coins >= 30
          quick_replies = [["Use lifeline", "Use lifeline"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = [["Earn coins", "Earn coins"], ["My picks", "Upcoming"], ["Sweepcoins", "Sweepcoins"]]
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

  # def help_prizes
  #   message.typing_on
  #   sleep 1.5
  #   say "💔 I split up the $25 Amazon gift card amongst the winners for the day and send them out within 24 hours."
  #   sleep 2
  #   message.typing_on
  #   sleep 0.5
  #   say "🏆 I know, poor Emma, only offering $25 a day..."
  #   sleep 2
  #   message.typing_on
  #   sleep 1.5
  #   say "But hey, I'm growing super fast, thanks to you 😍"
  #   sleep 1
  #   message.typing_on
  #   sleep 1
  #   say "So the quicker we get put on the map, the more money & prizes I'll be able to offer 🙌", quick_replies: [["Got it!", "Got it!"]]
  #   stop_thread
  # end

  def help_with_spread
    message.typing_on
    sleep 0.5
    say "🔢 When you see a number like (-3.5) or (+3.5), that's called the spread."
    sleep 1.5
    message.typing_on
    sleep 1
    say "➖ A negative number means the favorite needs to win by MORE than the number to cover the spread."
    sleep 2
    message.typing_on
    sleep 1
    say "➕ A positive number means the underdog needs to keep it close and either win or not lose by MORE than the number.", quick_replies: [['Got it!', 'Got it!']]
    stop_thread
  end

  def help_picking_games
    message.typing_on
    sleep 0.5
    say "☝️  Make your picks against the spread."
    sleep 1
    message.typing_on
    sleep 1.5
    say "👉 You can always skip games, they'll be there waiting for you until gametime."
    sleep 1
    message.typing_on
    sleep 1.5
    say "🤞 Hit a streak of 4 and win your share of a $25 Amazon gift card!", quick_replies: [['Spread?', 'Spread?'], ['Prizes', 'Prizes'], ['Got it!', 'Got it!']]
    stop_thread
  end

  def how_to_play
    @api = Api.new
    @api.find_or_create('users', user.id)
    if @api.user.data.how_to_play_touched
      message.typing_on
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      message.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    else
      set('how to play touched', user.id)
      message.typing_on
      sleep 0.5
      say "Hey #{@api.user.first_name} 👋"
      sleep 0.5
      message.typing_on
      sleep 0.5
      say "One of the best ways to get unstuck is to simply write to me ✍️"
      sleep 1.5
      say "For example..."
      sleep 0.5
      message.typing_on
      sleep 0.5
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      message.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    end
  end

  def how_to_play_for_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    if @api.user.data.how_to_play_touched
      postback.typing_on
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      postback.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    else
      set('how to play touched', user.id)
      postback.typing_on
      sleep 0.5
      say "Hey #{@api.user.first_name} 👋"
      sleep 0.5
      postback.typing_on
      sleep 0.5
      say "One of the best ways to get unstuck is to simply write to me ✍️"
      sleep 1.5
      say "For example..."
      sleep 0.5
      postback.typing_on
      sleep 0.5
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      postback.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    end
  end
end

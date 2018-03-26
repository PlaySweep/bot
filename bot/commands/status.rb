require_relative '../constants/status'

module Commands
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
end
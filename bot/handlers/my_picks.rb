module Commands
  def handle_my_picks
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

  def handle_my_picks_for_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    options = ["😏, I like where your heads at", "You got this ✊"]
    begin
    if @api.user.images.any?
      if @api.user.data.status_changed
        set('status changed', user.id)
        begin
          postback.typing_on
          @api.for_picks('upcoming')
          return if @api.upcoming_picks.nil?
          next_up = @api.upcoming_picks.first
          if next_up
            if next_up.type == 'Game'
              say "I see here you've got the #{next_up.abbreviation} up next at #{next_up.action} against the #{next_up.opponent}..."
              sleep 1
              postback.typing_on
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
          # postback.typing_on
          # @api.for_picks('status')
          # quick_replies = [
          #   { content_type: 'text', title: "Select picks", payload: "Select picks" },
          #   { content_type: 'text', title: "Status", payload: "Status" }
          # ]
          # show_media(@api.user.images.for_status, quick_replies)
          stop_thread
        rescue Facebook::Messenger::FacebookError => e
          say "Whoops, I screwed up. Gimme a sec, I'll try again..."
          # send an alert postback
          stop_thread
        end
      else
        postback.typing_on
        @api.for_picks('upcoming')
        return if @api.upcoming_picks.nil?
        next_up = @api.upcoming_picks.first
        if next_up
          if next_up.type == 'Game'
            say "I see here you've got the #{next_up.abbreviation} up next at #{next_up.action} against the #{next_up.opponent}..."
            sleep 1
            postback.typing_on
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
        postback.typing_on
        @api.for_picks('upcoming')
        return if @api.upcoming_picks.nil?
        next_up = @api.upcoming_picks.first
        if next_up
          if next_up.type == 'Game'
            say "I see here you've got the #{next_up.abbreviation} up next at #{next_up.action} against the #{next_up.opponent}......"
            sleep 1
            postback.typing_on
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
            postback.typing_on
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
        # postback.typing_on
        # @api.for_picks('status')
        # quick_replies = [
        #   { content_type: 'text', title: "Select picks", payload: "Select picks" },
        #   { content_type: 'text', title: "Status", payload: "Status" }
        # ]
        # show_media(@api.user.images.for_status, quick_replies)
        stop_thread
      rescue Facebook::Messenger::FacebookError => e
        say "Whoops, I screwed up. Gimme a sec, I'll try again..."
        # send an alert postback
        stop_thread
      end
    end
    rescue Facebook::Messenger::FacebookError => e
      say "Whoops, I screwed up. Gimme a sec, I'll try again..."
      # send an alert postback
      stop_thread
    end
  end
end
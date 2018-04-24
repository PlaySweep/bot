module Commands
  def handle_my_picks
    @api = Api.new
    @api.fetch_user(user.id)
    if true# @api.user.data.pick_changed
      begin
        puts "I am about to create an image"
        say "One second, let me go grab your latest info ⏳"
        message.typing_on
        # @api.for_picks('status', user.id)
        puts "I am done now, about to show you the image..."
        stop_thread and return show_media_with_button(user.id, 'picks', @api.user.images.for_status)
      rescue Exception => e
        say "Phew, well I just tried reaching out and there must be a bad network connection\nBut you can still tap see below to see more details about your picks 👍"
        short_wait(:message)
        stop_thread and return show_media_with_button(user.id, 'picks', @api.user.images.for_status) # || hard_coded_image)
        puts "handle_my_picks error: #{e.inspect}"
      end
    else
      short_wait(:message)
      show_media_with_button(user.id, 'picks', "1240293409434043")
      stop_thread
    end
  end

  def handle_my_picks_for_postback
    @api = Api.new
    @api.fetch_user(user.id)
    if true# @api.user.data.pick_changed
      begin
        say "One second, let me go grab your latest info ⏳"
        postback.typing_on
        @api.for_picks('status', user.id)
        show_media_with_button(user.id, 'picks', @api.user.images.for_status)
        stop_thread
      rescue Exception => e
        puts "ERROR: #{e.inspect}"
      end
    else
      short_wait(:postback)
      show_media_with_button(user.id, 'picks', "1240293409434043")
      stop_thread
    end
  end
end
module Commands
  def redirect type
    #TODO make an api call to populate options
    case type
    when :start
      message.typing_on
      say "No time to waste, huh? 👍", quick_replies: ["Select picks"]
      stop_thread
    when :show_sports
      message.typing_on
      say "Tap on the sport bubbles when you see them to begin making your picks 👍", quick_replies: ["Select picks", "Status"]
      stop_thread
    when :catch
      message.typing_on
      say "Ok lets get to it then", quick_replies: ["Select picks", "Status"]
      stop_thread
    when :lifeline
      message.typing_on
      say "Ok nevermind then", quick_replies: ["Select picks", "Status"]
      stop_thread
    end
  end

  def short_wait type
    case type
    when :message
      message.typing_on
    when :postback
      postback.typing_on
    end
    sleep 0.5
  end

  def medium_wait type
    case type
    when :message
      message.typing_on
      sleep 1.5
    when :postback
      postback.typing_on
      sleep 1.5
    end
    message.typing_off
  end

  def long_wait type
    case type
    when :message
      message.typing_on
    when :postback
      postback.typing_on
    end
    sleep 2
  end
end
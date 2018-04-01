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
      say "Whoops, did you need help making picks?", quick_replies: ["Select picks", "Status", "How to play"]
      stop_thread
    when :blow_steam
      message.typing_on
      say "You don't wanna blow steam anymore? Okaayyy", quick_replies: ["Select picks", "Status"]
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
      m = message
    when :postback
      m = postback
    end
    m.typing_on
    sleep 0.5
  end

  def medium_wait type
    case type
    when :message
      m = message
    when :postback
      m = postback
    end
    m.typing_on
    sleep 1
  end

  def long_wait type
    case type
    when :message
      m = message
    when :postback
      m = postback
    end
    m.typing_on
    sleep 2
  end
end
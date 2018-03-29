module Commands
  def entry_to_show_sports
    handle_show_sports
  end

  def entry_to_no_sports_available
    handle_no_sports_available
  end

  def entry_to_status
    handle_status
  end

  def entry_to_status_postback
    handle_status_postback
  end

  def entry_to_my_picks
    handle_my_picks
  end

  def entry_to_friends
    handle_friends
  end

  def entry_to_friends_postback
    handle_friends_postback
  end

  def entry_to_blow_steam
    handle_blow_steam
  end

  def entry_to_fun
    handle_fun
  end
end
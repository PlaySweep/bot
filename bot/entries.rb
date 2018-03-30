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

  def entry_to_my_picks_postback
    handle_my_picks_for_postback
  end

  def entry_to_sweepcoins
    handle_sweepcoins
  end

  def entry_to_sweepcoins_postback
    handle_sweepcoins_for_postback
  end

  def entry_to_notifications
    handle_manage_notifications
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

  def entry_to_lifeline
    handle_lifeline
  end
end
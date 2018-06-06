module Commands

  # def entry_to_dashboard
  #   handle_dashboard
  # end 

  def entry_to_location
    handle_location
  end

  def entry_to_email
    handle_email
  end

  def entry_to_dashboard_postback
    handle_dashboard_postback
  end

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

  # def entry_to_my_picks
  #   handle_my_picks
  # end

  # def entry_to_my_picks_postback
  #   handle_my_picks_for_postback
  # end

  def entry_to_sweepcoins
    handle_sweepcoins
  end

  def entry_to_earning_coins
    handle_earning_coins
  end

  def entry_to_notifications
    handle_manage_notifications
  end

  def entry_to_challenge
    handle_challenge_intro
  end

  def entry_to_challenge_response
    handle_challenge_response
  end

  def entry_to_challenge_postback
    handle_challenge_intro_postback
  end

  def entry_to_feedback
    handle_feedback
  end

  def entry_to_blow_steam
    handle_blow_steam
  end

  def entry_to_fun
    handle_fun
  end

  def entry_to_prizing
    handle_prizing
  end

  def entry_to_lifeline
    handle_lifeline
  end

  def entry_to_not_enough_for_lifeline
    handle_not_enough_for_lifeline
  end

  # def entry_to_how_to_play
  #   handle_how_to_play
  # end

  def entry_to_earn_coins
    handle_earn_coins
  end

end
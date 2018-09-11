module Commands

  def entry_to_location
    handle_location
  end

  def entry_to_email
    handle_email
  end

  def entry_to_status
    handle_status
  end

  def entry_to_status_postback
    handle_status
  end

  def entry_to_notifications
    handle_manage_notifications
  end

  def entry_to_feedback
    handle_feedback
  end

  def entry_to_fun
    handle_fun
  end

end
module Commands

  def handle_fun
    say FUN.sample, quick_replies: ["Select picks"]
    stop_thread
  end

end
module Commands
  def handle_how_to_play
    quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    show_button("🤔 How to play", "Not sure whats going on? Looking for your gift card? Tap below to refresh yourself on the rules of the game 👍", quick_replies)
  end
end
module Commands
  def handle_sweepstore
    quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    show_button("🛍 Sweepstore", "Tap below to check out what we offer 👍", quick_replies)
  end
end
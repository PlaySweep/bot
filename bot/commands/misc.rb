module Commands
  def catch
    emojis = %w[😏 🤑 😇 👌 🤗 👍 😉 😎]
    message.typing_on
    say emojis.sample, quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  end

  def emoji_response
    emojis = %w[😏 🤑 😇 👌 🤗 👍 😉 😎]
    message.typing_on
    say emojis.sample
    stop_thread
  end

  def redirect msg
    @api = Api.new
    @api.find_or_create('users', user.id)
    # send data (msg) to get smarter
    message.typing_on
    say "Hmm 💭...I must have dozed off 😴", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  end
end
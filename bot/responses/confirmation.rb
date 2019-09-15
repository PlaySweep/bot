def account_confirmation
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  copy = sweepy.copies.find { |copy| copy.category == "Confirm Account Prompt" }
  confirmation_text = copy.message
  url = "#{ENV['WEBVIEW_URL']}/confirmation/#{sweepy.slug}"
  show_button("Quick Setup ⚡️", confirmation_text, nil, url)
  stop_thread
  message.typing_off
end
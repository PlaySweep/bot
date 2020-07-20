def account_confirmation
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  copy = sweepy.copies.find { |copy| copy.category == "Confirm Account Prompt" }
  confirmation_text = copy.message
  quick_replies = [{content_type: :text, title: "Help", payload: "HELP"}]
  url = "#{ENV['WEBVIEW_URL']}/messenger/#{sweepy.facebook_uuid}"
  show_button("Sign up now!", confirmation_text, quick_replies, url)
  stop_thread
  
end
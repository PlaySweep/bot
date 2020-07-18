def start_help
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Talk to human", payload: "HUMAN"}, {content_type: :text, title: "How to play", payload: "HOW TO PLAY START"}]
  say "How can I help, #{sweepy.first_name}?", quick_replies: quick_replies
  stop_thread
  
end

def help
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}]
  url= "#{ENV["WEBVIEW_URL"]}/customer_support/#{sweepy.slug}"
  show_button("Reach out to us!", "Let us know what's up and we'll get back to you as soon as possible.", quick_replies, url)
  stop_thread
  
end
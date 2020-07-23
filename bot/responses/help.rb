def start_help
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Talk to human", payload: "HUMAN"}, {content_type: :text, title: "How to play", payload: "HOW TO PLAY START"}]
  say "How can I help, #{sweepy.first_name}?", quick_replies: quick_replies
  stop_thread
end

def help
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.confirmed
    quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}]
    url = "#{ENV['WEBVIEW_URL']}/user/support"
    show_button("Reach out to us!", "Let us know what's up and we'll get back to you as soon as possible.", quick_replies, url)
  else
    quick_replies = [{content_type: :text, title: "Sign up now!", payload: "PLAY READY"}]
    url = "#{ENV['WEBVIEW_URL']}/user/support"
    show_button("Reach out to us!", "Let us know what's up and we'll get back to you as soon as possible.", quick_replies, url)
  end
  stop_thread
end
def positive_sentiment
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Help", payload: "HUMAN"}]
  say "I'm picking up good vibes 🍺", quick_replies: quick_replies
  stop_thread
end

def negative_sentiment
  # @sweepy = Sweep::User.find(facebook_uuid: user.id)
  # @sweepy.unsubscribe
  say "👎"
  stop_thread
end

def neutral_sentiment
  # @sweepy = Sweep::User.find(facebook_uuid: user.id)
  # @sweepy.unsubscribe
  say "👐"
  stop_thread
end
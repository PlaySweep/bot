def positive_sentiment
  # @sweepy = Sweep::User.find(facebook_uuid: user.id)
  # @sweepy.unsubscribe
  say "👍"
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
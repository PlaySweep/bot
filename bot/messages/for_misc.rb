def listen_for_misc
  for_blow_steam
  for_fun
end

def for_blow_steam
  keywords = %w[fuck shit bitch crap suck sucks ugh damn dammit ah no]
  msg = message.text.split(' ').map(&:downcase).map(&:squeeze)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_blow_steam, reply_with: {
    text: ANGRY.sample,
    quick_replies: [["I need to vent 😤", "Vent"], ["I'm ok...", "I'm ok..."]]
  } if matched.any?
end

def for_fun
  keywords = %w[good thanks! thanks awesome! awesome thank you cool great great! wonderful sweet sweet!]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_fun, reply_with: {
    text: RANDOM_EMOJIS.sample,
    quick_replies: [["Tell me something", "Tell me something"]]
  } if matched.any?
end
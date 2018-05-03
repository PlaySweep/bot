def listen_for_misc
  for_blow_steam
  for_fun
  # how_do_i
end

# def how_do_i
#   if message.text.downcase.split(' ').include?('how')
#     msg = message.text.split(' ').map(&:downcase)
#     condition = msg.permutation(3).to_a.any? {|p| p == ['how', 'do', 'i'] || p == ['how', 'can', 'i'] } 
#     if condition
#       if msg.include?('challenge')
#         say "You want to know how to create a challenge?"
#         stop_thread
#       end
#     end
#   end
# end

def for_blow_steam
  keywords = %w[fuck shit bitch crap suck sucks ugh damn dammit ah no]
  msg = message.text.split(' ').map(&:downcase).map(&:squeeze)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_blow_steam, reply_with: {
    text: ANGRY.sample,
    quick_replies: [["😤", "VENT"], ["I'm ok...", "I'M OK"]]
  } if matched.any?
end

def for_fun
  keywords = %w[good thanks! thanks awesome! awesome thank you cool great great! wonderful sweet sweet! hi whats what's up]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_fun, reply_with: {
    text: RANDOM_EMOJIS.sample,
    quick_replies: ["Tell me something"]
  } if matched.any?
end
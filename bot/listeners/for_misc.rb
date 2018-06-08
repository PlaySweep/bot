def listen_for_misc
  stop_thread and return if message.text.nil?
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
  keywords = %w[thanks! thanks awesome! awesome cool! nice nice! go! great great! wonderful sweet sweet!]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  multiple_keywords, multiple_msg = ["let's go!", "let's go", "thank you!", "thank you"], message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase }
  double_matched = (multiple_keywords & multiple_msg)
  bind keywords, all: true, to: :entry_to_fun if matched.any?
  bind multiple_keywords, all: true, to: :entry_to_fun if double_matched.any?
end
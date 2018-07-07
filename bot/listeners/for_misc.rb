def listen_for_misc
  stop_thread and return if message.text.nil?
  for_blow_steam
  for_fun
end

def for_blow_steam
  keywords = %w[fuck! fuck shit! shit bitch! bitch sucks! sucks damn! damn]
  msg = message.text.split(' ').map(&:downcase).map(&:squeeze)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_blow_steam if matched.any?
end

def for_fun
  keywords = %w[hi hi! hello hello! ok ok! thanks! thanks awesome! awesome cool! nice nice! go! great great! wonderful sweet sweet!]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  multiple_keywords, multiple_msg = ["hell yeah!", "hell yeah", "thank you!", "thank you"], message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase }
  double_matched = (multiple_keywords & multiple_msg)
  bind keywords, all: true, to: :entry_to_fun if matched.any?
  bind multiple_keywords, all: true, to: :entry_to_fun if double_matched.any?
end
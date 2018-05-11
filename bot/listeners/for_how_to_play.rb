def listen_for_how_to_play
  #TODO handle all of this
  single_keywords, msg = ['help', 'confused'], message.text.split(' ').map(&:downcase)
  multiple_keywords, multiple_msg = ['how to', 'need help', 'where is', 'gift card', '24 hours'], message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase } 
  single_matched, double_matched = (single_keywords & msg), (multiple_keywords & multiple_msg)
  bind single_keywords, to: :entry_to_how_to_play if single_matched.any?
  bind multiple_keywords, to: :entry_to_how_to_play if double_matched.any?
end
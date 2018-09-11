VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

def build_payload_for resource, data
  case resource
  when 'users'
    data.map(&:full_name).first(5).each_slice(1).to_a.each_with_index do |user, index|
      user.push("#{data[index].full_name} #{data[index].facebook_uuid}")
    end
  when 'matchup'
    #matchups
  when 'notifications'
    quick_replies = []
    data.map(&:name).each_slice(1).to_a.each do |sport|
      quick_replies.push(["On", "#{sport[0].upcase} ON"], ["Off", "#{sport[0].upcase} OFF"])
    end
    quick_replies
  end
end


def capture_responses message
  options = ["I'm more effective when you say things like 'Make picks' or 'Whats my status?' 😁", "Curious about stuff? Just type 'Sweepcoins' or 'Select picks' to get a response 👍"]
  say options.sample
  stop_thread
end

def strip_emoji text
  text = I18n.transliterate(text)
  text.gsub(/[^\p{L}\s]+/, '').squeeze(' ').strip
end

def to_dollars amount
  '%.2f' % (amount.to_f / 100.0)
end

def is_a_valid_email? email
  return true if (email =~ VALID_EMAIL_REGEX) == 0
end

def find_best_streak streaks:
  first_tier, second_tier, third_tier = [], [], []
  return streaks[0] if streaks[1] == nil
  streaks.map do |streak|
    if streak % 4 == 3
      first_tier << streak
    elsif streak % 4 == 2
      second_tier << streak
    elsif streak % 4 == 1
      third_tier << streak
    end
  end
  return first_tier.max if first_tier.any?
  return second_tier.max if second_tier.any?
  return third_tier.max if third_tier.any?
end
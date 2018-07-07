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

def build_text_for resource:, object: nil, options: nil
  text = ""
  case resource
  when :matchup
    text.concat("#{object.away_side.action} #{object.type == 'Game' ? '@' : 'or'} #{object.home_side.action}\n\nStarting #{object.custom_time}\n📅 #{object.display_time}")
  when :matchups
    sleep 1
    object.each_with_index do |matchup, index|
      if matchup.type == 'Game'
        text.concat("#{index+1} #{matchup.away_side.abbreviation} vs #{matchup.home_side.abbreviation} #{SPORT_EMOJIS[matchup.sport.to_sym] || SPORT_EMOJIS[:random]}\n")
      elsif matchup.type == 'Prop'
        text.concat("#{index+1} #{matchup.context} #{SPORT_EMOJIS[matchup.sport.to_sym] || SPORT_EMOJIS[:random]}\n")
      end
    end
  when :picks
    upcoming = object.select {|pick| pick.status == 'pending' }
    in_progress = object.select {|pick| pick.status == 'in_progress' }
    text = for_in_flight(upcoming, in_progress) if in_progress.size > 0
    text = for_upcoming(object) if in_progress.size == 0
  when :status
    conn = Api.new
    case options
    when :winning_sweep
      copies = conn.fetch_copy(facebook_uuid: user.id, category: 'Status Winning Sweep')
      text = copies.last(5).map(&:message).sample
    when :winning_streak
      copies = conn.fetch_copy(facebook_uuid: user.id, category: 'Status Winning Streak')
      text = copies.last(5).map(&:message).sample
    when :should_use_lifeline
      copies = conn.fetch_copy(facebook_uuid: user.id, category: 'Status Store')
      text = copies.last(5).map(&:message).sample
    when :should_use_lifeline_but_cant
      copies = conn.fetch_copy(facebook_uuid: user.id, category: 'Status Earn Coins')
      text = copies.last(5).map(&:message).sample
    when :losing_streak
      copies = conn.fetch_copy(facebook_uuid: user.id, category: 'Status Losing Streak')
      text = copies.last(5).map(&:message).sample
    when :losing_sweep
      copies = conn.fetch_copy(facebook_uuid: user.id, category: 'Status Losing Sweep')
      text = copies.last(5).map(&:message).sample
    end
  when :challenges
    pending = object.select {|challenge| challenge.status == 'Pending'}
    accepted = object.select {|challenge| challenge.status == 'Accepted'}
    if pending.size > 0 && accepted.size > 0
      short_wait(options)
      say "I see #{pending.size} pending and #{accepted.size} active challenges 😲"
      short_wait(options)
      say "You busy little 🐝"
    elsif (pending.size > 0)
      pending.size == 1 ? challenges = 'challenge' : challenges = 'challenges'
      short_wait(options)
      say "I got #{pending.size} pending #{challenges} for you ☺️"
      #TODO add more sayings
    elsif (accepted.size > 0)
      accepted.size == 1 ? challenges = 'challenge' : challenges = 'challenges'
      short_wait(options)
      say "I count #{accepted.size} active #{challenges} 😎"
      #TODO add more sayings
    end
  end
  text
end

def for_upcoming picks
  picks.size == 1 ? games = "game" : games = "games"
  text = "#{picks.size} upcoming #{games} 🙌\n"
  picks.first(3).each do |pick|
    pick.type == 'Game' ? display_selected = pick.abbreviation : display_selected = pick.display_selected
    text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{display_selected}\n")
  end
  additional_text = "\n..."
  text.concat(additional_text) if picks.size > 3
  text
end

def for_in_flight upcoming, in_progress
  upcoming.size == 1 ? games = "game" : games = "games"
  upcoming_text = "#{upcoming.size} upcoming #{games} 🙌\n"
  upcoming.first(2).each_with_index do |pick, index|
    pick.type == 'Game' ? display_selected = pick.abbreviation : display_selected = pick.display_selected
    upcoming_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{display_selected}\n")
    upcoming_text.concat("...\n") if (index >= upcoming.first(2).size - 1) && upcoming.size > 2
  end
  in_progress.size == 1 ? games = "game" : games = "games"
  in_progress_text = "\n#{in_progress.size} #{games} in progress 🎥\n"
  in_progress.first(2).each_with_index do |pick, index|
    pick.type == 'Game' ? display_selected = pick.abbreviation : display_selected = pick.display_selected
    in_progress_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{display_selected}\n")
    in_progress_text.concat("...\n") if (index >= in_progress.first(2).size - 1) && in_progress.size > 2
  end
  additional_text = "\n...and more 👇"
  text = upcoming_text + in_progress_text
  text.concat(additional_text) if (upcoming.size + in_progress.size) >= 4
  text
end

def build_card_for resource, data
  # case resource
  # when :challenge
  #   pending_count, accepted_count = 0, 0
  #   status = data.map(&:status)
  #   status.each do |challenge_status|
  #     pending_count += 1 if challenge_status == 'Pending'
  #     accepted_count += 1 if challenge_status == 'Accepted'
  #   end
  #   card = [
  #     {
  #       title: "Pending: #{pending_count} | Active: #{accepted_count}",
  #       image_url: 'https://i.imgur.com/8F4EOpX.png',
  #       buttons: [
  #         {
  #           type: "web_url", url: "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}", title: "My Challenges", messenger_extensions: true
  #         }
  #       ]
  #     }
  #   ]
  # end
end

def build_custom_message challenge
  text = ""
  case challenge.type
  when 'Most Wins'
    text = "is challenging you for #{challenge.wager.coins} Sweepcoins on who will have the most wins in the span of #{challenge.duration_details.days} days!\n\nThe challenge duration will begin once you accept 👍"
  when 'Matchup'
    options = ["What say you?! 😶", "What you gonna do about it? 🤔", "You think you can take em' or what? 🙏"]
    if challenge.matchup_details.game_type == 'Game'
      text = "is challenging you to take #{challenge.matchup_details.acceptor.selected.display_selected} against #{challenge.matchup_details.requestor.selected.display_selected} for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
    elsif challenge.matchup_details.game_type == 'Prop'
      text = "is challenging you to take #{challenge.matchup_details.acceptor.selected.team_name} for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
    end
  end
  text
end

def capture_responses message
  random_defaults = [['Select picks', 'Status'], ['Challenges', 'Select picks'], ['Sweepcoins', 'Status']]
  quick_reply_options = ["Got questions?", "Send feedback", "Need help?"]
  say RANDOM.sample, quick_replies: [random_defaults.sample, quick_reply_options.sample].flatten
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
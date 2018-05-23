def build_payload_for resource, data
  case resource
  when 'users'
    data.map(&:full_name).first(4).each_slice(1).to_a.each_with_index do |user, index|
      user.push("#{data[index].full_name} #{data[index].facebook_uuid}")
    end
  when 'matchup'
    
  end
end

def build_text_for resource:, object:, options: nil
  text = ""
  case resource
  when :matchups
    options == :message ? wait = medium_wait(:message) : wait = medium_wait(:postback)
    wait
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
    case options
    when :winning_streak
      text = "#{STATUS_HOT.sample}\n\nWinning streak is #{object.current_streak}\n\nTap below for more details 👇"
    when :should_use_lifeline
      text = "Losing streak #{object.current_losing_streak} 👍\nWinning streak #{object.current_streak} 👎\n\nSet yourself back to a winning streak of #{object.previous_streak} with a lifeline...\nOr continue the losing road to a Sweep by picking the opposite side 🙌"
    when :should_use_lifeline_but_cant
      text = "Your losing streak is at #{object.current_losing_streak}, but all you need is #{30 - object.data.sweep_coins} more Sweepcoins to set your winning streak back to #{object.previous_streak}\n\nInvite or challenge your friends for more 🤝"
    when :losing_streak
      text = "#{STATUS_COLD.sample}\n\nYour losing streak is #{object.current_losing_streak}\n\nMaybe picking the opposite side is your thing 🤑"
    end
  when :challenges
    pending = object.select {|challenge| challenge.status == 'Pending'}
    accepted = object.select {|challenge| challenge.status == 'Accepted'}
    options == :message ? wait = short_wait(:message) : wait = short_wait(:postback)
    if pending.size > 0 && accepted.size > 0
      wait
      say "I see #{pending.size} pending and #{accepted.size} active challenges 😲"
      wait
      text = "You can respond or check your current status by tapping below 🤑"
    elsif (pending.size > 0)
      pending.size == 1 ? challenges = 'challenge' : challenges = 'challenges'
      wait
      say "I got #{pending.size} pending #{challenges} for you ☺️"
      wait
      text = "Tap below to accept or decline 🤑"
    elsif (accepted.size > 0)
      accepted.size == 1 ? challenges = 'challenge' : challenges = 'challenges'
      wait
      say "I count #{accepted.size} active #{challenges} 😎"
      wait
      text = "Tap below to check your current status 🤑"
    end
  end
  text
end

def for_upcoming picks
  picks.size == 1 ? games = "game" : games = "games"
  text = "#{picks.size} upcoming #{games} 🙌\n"
  picks.first(3).each do |pick|
    text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{pick.abbreviation} (#{pick.action})\n")
  end
  additional_text = "\n...tap to see more details 👇"
  text.concat(additional_text) if picks.size > 3
  text
end

def for_in_flight upcoming, in_progress
  upcoming.size == 1 ? games = "game" : games = "games"
  upcoming_text = "#{upcoming.size} upcoming #{games} 🙌\n"
  upcoming.first(2).each_with_index do |pick, index|
    upcoming_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{pick.abbreviation} (#{pick.action})\n")
    upcoming_text.concat("...\n") if (index >= upcoming.first(2).size - 1) && upcoming.size > 2
  end
  in_progress.size == 1 ? games = "game" : games = "games"
  in_progress_text = "\n#{in_progress.size} #{games} in progress 🎥\n"
  in_progress.first(2).each_with_index do |pick, index|
    in_progress_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{pick.abbreviation} (#{pick.action})\n")
    in_progress_text.concat("...and more\n") if (index >= in_progress.first(2).size - 1) && in_progress.size > 2
  end
  additional_text = "\n...tap to see more details 👇"
  text = upcoming_text + in_progress_text
  text.concat(additional_text) if (upcoming.size + in_progress.size) >= 4
  text
end

def build_card_for resource, data
  case resource
  when :challenge
    pending_count, accepted_count = 0, 0
    status = data.map(&:status)
    status.each do |challenge_status|
      pending_count += 1 if challenge_status == 'Pending'
      accepted_count += 1 if challenge_status == 'Accepted'
    end
    card = [
      {
        title: "Pending: #{pending_count} | Active: #{accepted_count}",
        # TODO challenge image
        image_url: 'https://i.imgur.com/8F4EOpX.png',
        buttons: [
          {
            type: "web_url", url: "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}", title: "Show Challenges", messenger_extensions: true
          }
        ]
      }
    ]
  end
end

def build_custom_message challenge
  text = ""
  case challenge.type
  when 'Most Wins'
    text = "is challenging you for #{challenge.wager.coins} Sweepcoins on who will have the most wins in the span of #{challenge.duration_details.days} days!\n\nThe challenge duration will begin once you accept 👍"
  when 'Matchup'
    options = ["What say you?! 😶", "What you gonna do about it? 🤔", "You think you can take em' or what? 🙏"]
    if challenge.matchup_details.game_type == 'Game'
      text = "is challenging you to take the #{challenge.matchup_details.acceptor.selected.team_name} (#{challenge.matchup_details.acceptor.selected.action}) against the #{challenge.matchup_details.requestor.selected.team_name} (#{challenge.matchup_details.requestor.selected.action}) for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
    elsif challenge.matchup_details.game_type == 'Prop'
      text = "is challenging you to take #{challenge.matchup_details.acceptor.selected.team_name} for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
    end
  end
  text
end

def capture_responses message
  #TODO update facebook_uuids for prod 
  [1594944847261256].each do |facebook_uuid|
    message_options = {
      messaging_type: "UPDATE",
      recipient: { id: facebook_uuid },
      message: {
        text: "Unrecognized response,\n\n#{message}",
      }
    }
    Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  end
  quick_reply_options = ["Got questions?", "Send feedback", "Need help?"]
  say RANDOM.sample, quick_replies: [quick_reply_options.sample]
  stop_thread
end

def strip_emoji text
  text.gsub(/[^\p{L}\s]+/, '').squeeze(' ').strip
end
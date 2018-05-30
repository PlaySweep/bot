def build_payload_for resource, data
  case resource
  when 'users'
    data.map(&:full_name).first(5).each_slice(1).to_a.each_with_index do |user, index|
      user.push("#{data[index].full_name} #{data[index].facebook_uuid}")
    end
  when 'matchup'
    
  end
end

def build_text_for resource:, object:, options: nil
  text = ""
  case resource
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
    case options
    when :winning_streak
      responses = [
        "I am so proud of you 🤗, let's keep that streak of #{object.current_streak} going!",
        "You're in the green, sports fiend with #{object.current_streak} straight wins 🥑", 
        "Hot dog 🌭 you've gotta be loving that winning streak of #{object.current_streak} right about now...",
        "Nom nom nom 🍔 you just keep on crushin' it with #{object.current_streak} wins in a row!",
        "Those #{object.current_streak} wins in a row got you ridin' dirty 🤠",
        "#{object.current_streak} wins in a row? I see a Sweep deep in the horizon for you 😎"
      ]
      text = responses.sample
    when :should_use_lifeline
      short_wait(:message)
      say STATUS_COLD.sample
      responses = [
        "Just when you thought you were out, I found a lifeline for you! Set your winning streak back to #{object.previous_streak} for 30 Sweepcoins 💸",
        "Emma says, Would you like to use a lifeline? #{object.current_losing_streak} loss ain't bad, but you can still set your winning streak back to #{object.previous_streak} for 30 Sweepcoins 💸",
        "I found a lifeline! Roll with #{object.current_losing_streak} loss if you want, but a streak of #{object.previous_streak} for 30 Sweepcoins is a pretty good deal 🚑",
        "Flip the script with a lifeline and set that streak back to #{object.previous_streak} 👈"
      ]
      text = responses.sample
    when :should_use_lifeline_but_cant
      responses = [
        "You may not be a winner right now, but #{object.current_losing_streak} loss in a row doesn't make you a loser either 😑",
        "Eh, #{object.current_losing_streak} loss in a row isn't so hot, but you can call your mom. She'll build your self esteem right back up 😃",
        "Umm, you need a redo maybe? Invite your friends to play to get you back to #{object.previous_streak} in a row...all you need is #{30 - object.data.sweep_coins} more Sweepcoins for a lifeline 🤑",
        "You can’t do this alone. Invite your ride or dies to Sweep for a lifeline...you're #{30 - object.data.sweep_coins} Sweepcoins away from earning a lifeline 🚑"
      ]
      text = responses.sample
    when :losing_streak
      text = "#{STATUS_COLD.sample}\n\nYour losing streak is #{object.current_losing_streak}\n\nMaybe picking the opposite side is your thing 🤑"
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
      text = "is challenging you to take the #{challenge.matchup_details.acceptor.selected.team_name} (#{challenge.matchup_details.acceptor.selected.action}) against the #{challenge.matchup_details.requestor.selected.team_name} (#{challenge.matchup_details.requestor.selected.action}) for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
    elsif challenge.matchup_details.game_type == 'Prop'
      text = "is challenging you to take #{challenge.matchup_details.acceptor.selected.team_name} for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
    end
  end
  text
end

def capture_responses message
  [1566539433429514].each do |facebook_uuid|
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
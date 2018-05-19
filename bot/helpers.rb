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
    puts "STATUS: #{status}"
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
  #TODO test messages
  case challenge.type
  when 'Most Wins'
    "wants to challenge you to #{challenge.wager.coins} Sweepcoins on who will have the most wins in the span of #{challenge.duration_details.days} days!\n\nThe challenge duration will begin once you hit accept 👍"
  when 'Matchup'
    options = ["What say you?! 😶", "What you gonna do about it? 🤔", "You think you can take em' or what? 🙏"]
    "wants to challenge you to take the #{challenge.matchup_details.acceptor.selected.team_name} against the spread (#{challenge.matchup_details.acceptor.selected.action}) against the #{challenge.matchup_details.requestor.selected.team_name} (#{challenge.matchup_details.requestor.action}) for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
  end
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
  say RANDOM.sample, quick_replies: ["Send feedback"]
  stop_thread
end
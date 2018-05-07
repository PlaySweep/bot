def build_payload_for resource, data
  case resource
  when 'users'
    data.map(&:full_name).first(4).each_slice(1).to_a.each_with_index do |user, index|
      user.push("#{data[index].full_name} #{data[index].facebook_uuid}")
    end
  when 'matchup'
    
  end
end

def build_text_for resource:, data:
  text = ""
  case resource
  when :picks
    upcoming = data.select {|pick| pick.status == 'pending' }
    in_progress = data.select {|pick| pick.status == 'in_progress' }
    text = for_in_flight(upcoming, in_progress) if in_progress.size > 0
    text = for_upcoming(data) if in_progress.size == 0
  end
  text
end

def for_upcoming picks
  picks.size == 1 ? games = "game" : games = "games"
  text = "#{picks.size} upcoming #{games} 🙌\n"
  picks.first(3).each do |pick|
    text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{pick.abbreviation} (#{pick.action})\n")
  end
  additional_text = "\n...and more 👇"
  text.concat(additional_text) if picks.size > 3
  text
end

def for_in_flight upcoming, in_progress
  upcoming.size == 1 ? games = "game" : games = "games"
  upcoming_text = "#{upcoming.size} upcoming #{games} 🙌\n"
  upcoming.first(2).each_with_index do |pick, index|
    upcoming_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{pick.abbreviation} (#{pick.action})\n")
    upcoming_text.concat("...plus more\n") if (index >= upcoming.first(2).size - 1) && upcoming.size > 2
  end
  in_progress.size == 1 ? games = "game" : games = "games"
  in_progress_text = "\n#{in_progress.size} #{games} in progress 🎥\n"
  in_progress.first(2).each_with_index do |pick, index|
    in_progress_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{pick.abbreviation} (#{pick.action})\n")
    in_progress_text.concat("...and more\n") if (index >= in_progress.first(2).size - 1) && in_progress.size > 2
  end
  additional_text = "\n...and more 👇"
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
      pending_count += 1 if challenge_status == 'pending'
      accepted_count += 1 if challenge_status == 'accepted'
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
  case challenge.description
  when 'Most Wins'
    "wants to challenge you on who will have the most wins in the span of #{challenge.duration_details.days} days!\n\nThe challenge duration will begin once you hit accept 👍"
  when 'Matchup'
    "wants to challenge you to take the #{challenge.matchup_details.acceptor.selected} against the spread (#{challenge.matchup_details.acceptor.spread}) against the #{challenge.matchup_details.requestor.selected} (#{challenge.matchup_details.requestor.spread})\n\nTap accept or decline below 👍"
  end
end
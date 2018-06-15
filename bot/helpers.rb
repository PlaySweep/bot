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

def build_text_for resource:, object:, options: nil
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
    case options
    when :winning_sweep
      responses = [
        "Damn, you lookin good at #{object.current_streak} wins in a row, you been workin out your picks? 😉",
        "You just like being reminded you're at #{object.current_streak} wins in a row, don't you? 😉🎉",
        "Is that a winning streak of #{object.current_streak} now? You’re peaking! Like MJ in 93, Lebron in 18...keep it goin' 🎉",
        "Can I get an encore? Cause this #{object.current_streak} game win streak has been a heck of a performance 🎤",
        "I'd pour Gatorade all over you and your #{object.current_streak} game win streak if I could 🏅",
        "I'm gonna start losing count of your #{object.current_streak} game win streak here pretty soon...🔢💯",
        "Ok, you're at #{object.current_streak} wins straight now, time to brag to your friends and earn some more Sweepcoins ☎️"
      ]
      text = responses.sample
    when :winning_streak
      object.current_streak > 1 ? wins = 'wins' : wins = 'win'
      responses = [
        "I am so proud of you 🤗, let's keep that streak of #{object.current_streak} going!",
        "You're in the green, sports fiend with #{object.current_streak} straight #{wins} 🥑", 
        "Hot dog 🌭 you've gotta be loving that winning streak of #{object.current_streak} right about now...",
        "Nom nom nom 🍔 you just keep on crushin' it with #{object.current_streak} #{wins} in a row!",
        "#{object.current_streak} straight #{wins} has got you ridin' dirty 🤠",
        "#{object.current_streak} #{wins} in a row? I see a Sweep deep in the horizon for you 😎",
        "Stop winning! #{object.current_streak} in a row...I can't afford to keep paying you! (JK, keep winning 💰💰💰)"
      ]
      text = responses.sample
    when :should_use_lifeline
      responses = [
        "Just when you thought you were out...use a lifeline and get your winning streak back to #{object.previous_streak} 💸",
        "Emma says, Would you like to use a lifeline? #{object.current_losing_streak} loss ain't bad, but a winning streak of #{object.previous_streak} is better, right? ✌️",
        "I found a lifeline! Roll with #{object.current_losing_streak} loss or trade in 30 Sweepcoins to get a winning streak of #{object.previous_streak} back 🚑",
        "Flip the script with a lifeline, set that streak back to #{object.previous_streak} 👇",
        "#{object.current_losing_streak} loss down and three more to go...or set your streak back to a winning streak of #{object.previous_streak} by using a lifeline 💰",
        "Get back to #{object.previous_streak} in a row with a lifeline, or continue the reverse Sweep starting with #{object.current_losing_streak} loss 🤷‍♀️",
        "Reincarnation is POSSIBLE...just use that little lifeline below and watch that streak flip back to #{object.previous_streak} 👇",
        "Normally, the game would be over 👾, but you have a lifeline. Get back in with a streak of #{object.previous_streak}"
      ]
      text = responses.sample
    when :should_use_lifeline_but_cant
      responses = [
        "You may not be a winner right now, but #{object.current_losing_streak} loss in a row doesn't make you a loser either 😑",
        "Eh, #{object.current_losing_streak} loss in a row isn't so hot, but you can call your mom. She'll build your self esteem right back up 😃",
        "Umm, you need a redo maybe? Invite your friends to play to get you back to #{object.previous_streak} in a row...all you need is #{30 - object.data.sweep_coins} more Sweepcoins for a lifeline 🤑",
        "You can’t do this alone. Invite your ride or dies to Sweep for a lifeline...you're #{30 - object.data.sweep_coins} Sweepcoins away from earning a lifeline 🚑",
        "Since you're only #{30 - object.data.sweep_coins} away from a lifeline, you can always fail your way to the top, starting with #{object.current_losing_streak} loss in a row 💸",
        "#{object.current_losing_streak} loss? That's ok. I'm not perfect either...challenge some friends for some more Sweepcoins so you can afford that lifeline 🤝"
      ]
      text = responses.sample
    when :losing_streak
      object.current_losing_streak > 1 ? times = 'times' : times = 'time'
      object.current_losing_streak > 1 ? losses = 'losses' : losses = 'loss'
      responses = [
        "#{object.current_losing_streak} #{losses} in a row? Welcome to the Loser’s Bracket...which is also the Winner’s Bracket 😝",
        "Keep this #{object.current_losing_streak} game losing streak up and you'll be 😂 your way all the way to the Amazon 🏦",
        "Wow, if everything in life was so rewarding when you lose #{object.current_losing_streak} #{times} in a row 😁",
        "Keep up your #{object.current_losing_streak} game losing streak and take that L with pride...it might make you some 💰",
        "I honestly didn't prepare for someone to be so good at losing, #{object.current_losing_streak} #{losses} and counting...",
        "Stop losing! #{object.current_losing_streak} in a row...I can't afford to keep paying you! (JK, keep losing 💰💰💰)",
        "Yeesh, #{object.current_losing_streak} game losing streak...maybe picking the opposite side is your thing 🤑"
      ]
      text = responses.sample
    when :losing_sweep
      object.current_losing_streak > 1 ? times = 'times' : times = 'time'
      object.current_losing_streak > 1 ? losses = 'losses' : losses = 'loss'
      responses = [
        "OK, you're cashing in on losing too much not to tell anyone 😋\n\nLet everyone and their second cousin know about your #{object.current_losing_streak} game losing streak and earn some Sweepcoins 💰",
        "You take pride in your losses, I can tell 😎...keep adding to your #{object.current_losing_streak} #{losses}!",
        "#{object.current_losing_streak} #{losses} in a row and no end in sight 👀! Tweet, Gram, Snap...tell your friends you're crushin' it 😏",
        "I don't get it either, but I'm paying you for this kind of losing streak...#{object.current_losing_streak} straight and counting 😏",
        "Apparently you've uncovered the secret to success, and it's losing #{object.current_losing_streak} #{times} in a row 👓📚"
      ]
      text = responses.sample
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
  additional_text = "\n...and more 👇"
  text.concat(additional_text) if picks.size > 3
  text
end

def for_in_flight upcoming, in_progress
  upcoming.size == 1 ? games = "game" : games = "games"
  upcoming_text = "#{upcoming.size} upcoming #{games} 🙌\n"
  upcoming.first(2).each_with_index do |pick, index|
    pick.type == 'Game' ? display_selected = pick.abbreviation : display_selected = pick.display_selected
    upcoming_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{display_selected})\n")
    upcoming_text.concat("...\n") if (index >= upcoming.first(2).size - 1) && upcoming.size > 2
  end
  in_progress.size == 1 ? games = "game" : games = "games"
  in_progress_text = "\n#{in_progress.size} #{games} in progress 🎥\n"
  in_progress.first(2).each_with_index do |pick, index|
    pick.type == 'Game' ? display_selected = pick.abbreviation : display_selected = pick.display_selected
    in_progress_text.concat("#{SPORT_EMOJIS[pick.sport.to_sym] || SPORT_EMOJIS[:random]} #{display_selected})\n")
    in_progress_text.concat("...and more\n") if (index >= in_progress.first(2).size - 1) && in_progress.size > 2
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
      text = "is challenging you to take the #{challenge.matchup_details.acceptor.selected.display_selected} against the #{challenge.matchup_details.requestor.selected.display_selected} for #{challenge.wager.coins} Sweepcoins!\n\n#{options.sample}"
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
  text.gsub(/[^\p{L}\s]+/, '').squeeze(' ').strip
end
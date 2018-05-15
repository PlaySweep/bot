# def listen_for_ads_postback
  # single_matchup
# end

# def single_matchup
#   case postback.payload.split(' ')[0]
#   when 'SINGLE_MATCHUP'
#     side1, side2 = postback.payload.split(' ')[1].split('_').join(' '), postback.payload.split(' ')[2].split('_').join(' ')
#     @api = Api.new
#     @api.find_or_create('users', user.id)
#     @api.fetch_matchup_by_teams(side1, side2)
#     handle_matchup(@api.matchup)
#   end
# end

# def handle_matchup matchup
#   away = matchup.away_side
#   home = matchup.home_side
#   quick_replies = [
#     { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
#     { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
#     { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
#   ]
#   short_wait(:postback)
#   say "Starting #{matchup.custom_time}\n#{matchup.display_time}"
#   short_wait(:postback)
#   show_media(matchup.attachment_id, quick_replies)
#   next_command :handle_pick
# end

# def skip
#   #TODO change copy and flow
#   @api = Api.new
#   @api.fetch_user(user.id)  
#   sport, matchup_id = message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
#   @api.update('matchups', matchup_id, { :matchup => {:skipped_by => @api.user.id} })
#   options = ["Skipped 👍", "You can always come back later and pick 🙌", "You got it 😉", "Consider it done 🤝"]
#   message.typing_on
#   sleep 0.5
#   say options.sample
#   sleep 0.5
#   message.typing_on
#   sleep 1
#   @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
#   fetch_matchup(sport, @api.matchups.first)
# end

# def handle_pick
#   #TODO change copy and flow
#   @api = Api.new
#   @api.fetch_user(user.id)
#   qr = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
#   #TODO Better button handling for unexpected requests
#   show_button("🤔 How to play", "Not sure whats going on? Tap below to refresh yourself on the rules of the game 👍", qr) and stop_thread and return if (!message.quick_reply && message.text)
#   show_button("Show Challenges", "Sorry, I was too focused on making picks 🙈\n\nTap below to respond to any pending challenges 👇", qr, "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}") and stop_thread and return if (message.quick_reply.split(' ')[1] == 'CHALLENGE')
#   sport, matchup_id, selected_id = message.quick_reply.split(' ')[0], message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
#   return if message.quick_reply.nil?
#   skip and return if message.quick_reply.split(' ')[0] == "Skip"
#   @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
#   games = @api.matchups && @api.matchups.count > 1 || @api.matchups && @api.matchups.count == 0 ? "games" : "game"
#   say "We have #{@api.matchups.count} #{sport} #{games} available" unless (matchup_id && selected_id || (@api.matchups.nil? || @api.matchups.empty?))
#   if matchup_id && selected_id
#     params = { :pick => {:user_id => @api.user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
#     @api.create('picks', user.id, params)
#     @api.update('users', user.id, { :user => {:active => true} }) unless @api.user.active
#     #TODO temporary method 👇
#     update_user_info unless (@api.user.profile_pic && @api.user.gender && @api.user.timezone)
#     message.typing_on
#     sleep 1
#     say "#{@api.pick.selected} (#{@api.pick.action}) ✅" unless @api.pick.nil?
#     message.typing_on
#     @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
#     sleep 1
#     fetch_matchup(sport, @api.matchups.first)
#   else
#     @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
#     fetch_matchup(sport, @api.matchups.first)
#   end
# end
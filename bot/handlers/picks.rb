module Commands
  def handle_show_sports
    @api = Api.new
    @api.fetch_sports
    # @api.sports.include?(message.quick_reply) ? handle_pick : redirect(:show_sports) and stop_thread
    if @api.sports.include?(message.quick_reply)
      handle_pick
    else
      redirect(:show_sports)
      stop_thread
    end
  end

  def handle_no_sports_available
    #TODO possibly add a call to special list of matchups in exchange for sweepcoins
    message.typing_on
    say "Nothing left to pick from. Check back later.", quick_replies: ["Status", "Challenges"]
    stop_thread
  end

  def handle_pick
    @api = Api.new
    @api.fetch_user(user.id)
    qr = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    show_button("🤔 How to play", "Not sure whats going on? Tap below to refresh yourself on the rules of the game 👍", qr) and stop_thread and return if (!message.quick_reply && message.text)
    sport, matchup_id, selected_id = message.quick_reply.split(' ')[0], message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    return if message.quick_reply.nil?
    skip and return if message.quick_reply.split(' ')[0] == "Skip"
    @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
    games = @api.matchups && @api.matchups.count > 1 || @api.matchups && @api.matchups.count == 0 ? "games" : "game"
    say "We have #{@api.matchups.count} #{sport} #{games} available" unless (matchup_id && selected_id || (@api.matchups.nil? || @api.matchups.empty?))
    if matchup_id && selected_id
      params = { :pick => {:user_id => @api.user.id, :matchup_id => matchup_id, :selected_id => selected_id} }
      @api.create('picks', user.id, params)
      message.typing_on
      sleep 1
      say "#{@api.pick.selected} (#{@api.pick.action}) ✅" unless @api.pick.nil?
      message.typing_on
      @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
      sleep 1
      fetch_matchup(sport, @api.matchups.first)
    else
      @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
      fetch_matchup(sport, @api.matchups.first)
    end
  end

  def skip
    @api = Api.new
    @api.fetch_user(user.id)  
    sport, matchup_id = message.quick_reply.split(' ')[1], message.quick_reply.split(' ')[2] unless message.quick_reply.nil?
    @api.update('matchups', matchup_id, { :matchup => {:skipped_by => @api.user.id} })
    options = ["Skipped 👍", "You can always come back later and pick 🙌", "You got it 😉", "Okie dokie 👉"]
    message.typing_on
    sleep 0.5
    say options.sample
    sleep 0.5
    message.typing_on
    sleep 1
    @api.fetch_all('matchups', user.id, sport.downcase) unless sport.nil?
    fetch_matchup(sport, @api.matchups.first)
  end

  def fetch_matchup sport, matchup
    if (matchup.nil? || matchup.empty?)
      say "All finished. I'll let you know when I find more games.", quick_replies: [["More sports", "Select picks"], ["Status", "Status"]]
      stop_thread
    else
      away = matchup.away_side
      home = matchup.home_side
      quick_replies = [
        { content_type: 'text', title: "#{away.abbreviation} (#{away.action})", payload: "#{matchup.sport} #{matchup.id} #{away.id}" },
        { content_type: 'text', title: "#{home.abbreviation} (#{home.action})", payload: "#{matchup.sport} #{matchup.id} #{home.id}" },
        { content_type: 'text', title: "Skip", payload: "Skip #{matchup.sport} #{matchup.id}" }
      ]
      message.typing_on
      sleep 0.5
      say "Starting #{matchup.custom_time}\n#{matchup.display_time}"
      sleep 1.5
      message.typing_on
      show_media(matchup.attachment_id, quick_replies)
      message.typing_off
      next_command :handle_pick
    end
  end
end
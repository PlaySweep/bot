module Commands
  def handle_show_challenges
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/contests"
    #TODO
    @contests = Sweep::Contest.all(facebook_uuid: user.id)
    unless @contests.empty? || @contests.nil?
      pending_contests = @contests.select { |contest| contest.status == "pending" }
      started_contests = @contests.select { |contest| contest.status == "started" }
      finished_contests = @contests.select { |contest| contest.status == "finished" }
      if pending_contests.any?
        contest = pending_contests.first
        show_button("Enter and WIN 💰!", "⭐️ FEATURED ⭐️\n#{contest.name}", nil, url)
        stop_thread
      elsif started_contests.any?
        contest = started_contests.first
        show_button("LIVE NOW ✨!", "⭐️ FEATURED ⭐️\n#{contest.name}", nil, url)
        stop_thread
      else
        say "No tournaments currently available, I'll have more soon!"
        stop_thread
      end
    else
      @sweepy = Sweep::User.find(user.id)
      if @sweepy.system_preference.data.tournaments
        say "No tournaments currently available, but I'll send you an update once one is up 🏆"
      else
        url = "#{ENV['WEBVIEW_URL']}/#{user.id}/preferences"
        show_button("Update Preferences", "No tournaments currently available. Get notified when new tournaments have been added 🏆", nil, url)
        stop_thread 
      end
    end
  end
end
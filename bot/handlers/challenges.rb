module Commands
  def handle_show_challenges
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/contests"
    #TODO
    @contests = Sweep::Contest.all(facebook_uuid: user.id)
    unless @contests.empty? || @contests.nil?
      @contest = @contests.first
      tournaments = @contests.length == 1 ? "tournament" : "tournaments"
      show_button("Enter and WIN 💰!", "#{@contests.length} #{tournaments} available!\n\n⭐️ FEATURED ⭐️\n#{@contest.name}", nil, url)
      stop_thread
    else
      @sweepy = Sweep::User.find(user.id)
      if @sweepy.system_preference.data.tournaments
        say "No tournaments available yet, but I'll make sure to send you an update once one is ready 🏆"
      else
        url = "#{ENV['WEBVIEW_URL']}/#{user.id}/preferences"
        show_button("Update Preferences", "No tournaments currently available. Get notified when new tournaments have been added 🏆", nil, url)
        stop_thread 
      end
    end
  end
end
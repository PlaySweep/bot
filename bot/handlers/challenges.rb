module Commands
  def handle_show_challenges
    quick_replies = [{ content_type: 'text', title: "Make picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }, { content_type: 'text', title: "Preferences", payload: "PREFERENCES" }]
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/contests"
    #TODO
    @contests = Sweep::Contest.all
    unless @contests.empty? || @contests.nil?
      puts @contests.inspect
      show_button("Enter now!", "We have #{@contests.length} tournaments available!\n\n⭐️ FEATURED ⭐️\n - #{@contest.name}", quick_replies, url)
      # stop_thread
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
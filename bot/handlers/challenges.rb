module Commands
  def handle_show_challenges
    quick_replies = [{ content_type: 'text', title: "Make picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }, { content_type: 'text', title: "Preferences", payload: "PREFERENCES" }]
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/contests"
    #TODO
    @contests = Sweep::Contest.all
    @contest = @contests.first
    if @contest.nil?
      say "Check back soon for newly added tournaments ⭐️"
      stop_thread
    elsif @contest.status == 'pending'
      show_button("Enter now!", "We have #{@contests.length} tournaments available!\n\n⭐️ FEATURED ⭐️\n - #{@contest.name}", quick_replies, url)
      stop_thread
    else
      say "Check back soon for newly added tournaments ⭐️"
      stop_thread
    end
  end

  # def resources
  #   @contests = Sweep::Contest.all
  #   if @contests.empty?
  #     say "No challenges available.", quick_replies: ["Make picks"]
  #     stop_thread
  #   else
  #       @contest = @contests.first
  #       [
  #        {
  #         title: "⭐️ FEATURED ⭐️",
  #         image_url: "http://www.playsweep.com/images/logo.png",
  #         subtitle: "#{@contest.name}",
  #         buttons: [
  #           {
  #             type: "web_url",
  #             url: "#{ENV['WEBVIEW_URL']}/#{user.id}/contests",
  #             title: "View Contests",
  #             webview_height_ratio: "full"
  #           }           
  #         ]      
  #       }
  #     ]
  #   end
  # end
end
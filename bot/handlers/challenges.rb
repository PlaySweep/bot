module Commands
  def handle_show_challenges
    quick_replies = [{ content_type: 'text', title: "Make picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }, { content_type: 'text', title: "Preferences", payload: "PREFERENCES" }]
    url = "#{ENV['WEBVIEW_URL']}/sweepcoins"
    show_carousel(resources, quick_replies)
    stop_thread
  end

  def resources
    @contest = Sweep::Contest.all.first
    [
     {
      title: "⭐️ FEATURED ⭐️",
      image_url: "http://www.playsweep.com/images/logo.png",
      subtitle: "#{@contest.name}",
      buttons: [
        {
          type: "web_url",
          url: "#{ENV['WEBVIEW_URL']}/#{user.id}/contests",
          title: "View Contests",
          webview_height_ratio: "tall"
        }           
      ]      
    },
     {
      title: "Battle your friends",
      image_url: "http://www.playsweep.com/images/logo.png",
      subtitle: "Earn some coins and some bragging rights 🤑",
      buttons: [
        {
          type: "web_url",
          url: "#{ENV['WEBVIEW_URL']}/#{user.id}/battles",
          title: "View Battles",
          webview_height_ratio: "tall"
        }             
      ]      
    }
  ]
  end
end
# module Commands
#   def handle_my_picks
#     @api = Api.new
#     @api.fetch_picks(user.id, :in_flight)
#     medium_wait(:message)
#     if @api.picks.size != 0
#       text = build_text_for(resource: :picks, object: @api.picks)
#       quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
#       url = "#{ENV['WEBVIEW_URL']}/picks/#{user.id}"
#       show_button("Show Picks", text, quick_replies, url)
#       stop_thread
#     else
#       #TODO handle in progress or complete picks option
#       say "You have no upcoming games 😲", quick_replies: ["Select picks", "Status"]
#       stop_thread
#     end
#   end

#   def handle_my_picks_for_postback
#     @api = Api.new
#     @api.fetch_picks(user.id, :in_flight)
#     medium_wait(:postback)
#     if @api.picks.size != 0
#       text = build_text_for(resource: :picks, object: @api.picks)
#       quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
#       url = "#{ENV['WEBVIEW_URL']}/picks/#{user.id}"
#       show_button("Show Picks", text, quick_replies, url)
#       stop_thread
#     else
#       #TODO handle in progress or complete picks option
#       say "You have no upcoming games 😲", quick_replies: ["Select picks", "Status"]
#       stop_thread
#     end
#   end
# end
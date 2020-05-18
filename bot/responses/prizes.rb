def start_prizes
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  url= "#{ENV["WEBVIEW_URL"]}/customer_support/#{sweepy.slug}"
  show_button("Request more info", "If you still have questions concerning a prize you've won, reach out to us below!", quick_replies, url)
  stop_thread
  
end

def general_prizing_info
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  prizing_copy = sweepy.copies.find { |copy| copy.category == "Prizing Info" }
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  say prizing_copy.message, quick_replies: quick_replies
  stop_thread
  
end

def my_prizing_info
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  url= "#{ENV["WEBVIEW_URL"]}/customer_support/#{sweepy.slug}"
  show_button("Request more info", "If you still have questions concerning a prize you've won, reach out to us below!", quick_replies, url)
  stop_thread
end
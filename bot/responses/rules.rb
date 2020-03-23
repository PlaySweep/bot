def show_rules
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  # rules_url = sweepy.links.find { |image| image.category == "Rules" }.url
  say "You can view the rules of the game below, #{sweepy.first_name}..."
  # show_button("View rules", "Official Rules", nil, rules_url)

  # terms_url = sweepy.links.find { |image| image.category == "Terms of Service" }.url
  # show_button("Terms of Service", "You can view the official Terms of Service by tapping below 👇", nil, terms_url)

  # privacy_url = sweepy.links.find { |image| image.category == "Privacy Policy" }.url
  # show_button("Privacy Policy", "You can view the official Privacy Policy by tapping below 👇", nil, privacy_url)
  
  stop_thread
  
end
def show_rules
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  rules_url = sweepy.links.find { |image| image.category == "Rules" }.url
  show_button("Rules", "You can view the official Rules by tapping below 👇", nil, rules_url)

  terms_url = sweepy.links.find { |image| image.category == "Terms of Service" }.url
  show_button("Terms of Service", "You can view the official Terms of Service by tapping below 👇", nil, terms_url)

  privacy_url = sweepy.links.find { |image| image.category == "Privacy Policy" }.url
  show_button("Privacy Policy", "You can view the official Privacy Policy by tapping below 👇", nil, privacy_url)
  
  stop_thread
  
end
def show_rules
  rules_url = "http://www.endemiclabs.co/budweiser-sweep-rules.html"
  show_button("Rules", "You can view the official Rules by tapping below 👇", nil, rules_url)

  terms_url = "https://www.budweiser.com/en/terms-conditions.html"
  show_button("Terms of Service", "You can view the official Terms of Service by tapping below 👇", nil, terms_url)

  privacy_url = "https://www.budweiser.com/en/privacy-policy.html"
  show_button("Privacy Policy", "You can view the official Privacy Policy by tapping below 👇", nil, privacy_url)
  
  stop_thread
end
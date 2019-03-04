def show_rules
  text = "You can view the official Rules, Terms of Service, and Privacy Policy by tapping below 👇"
  rules_url = "http://www.endemiclabs.co/budweiser-sweep-rules.html"
  show_button("Rules", text, nil, rules_url)

  terms_url = "https://www.budweiser.com/en/terms-conditions.html"
  show_button("Terms of Service", "", nil, terms_url)

  privacy_url = "https://www.budweiser.com/en/privacy-policy.html"
  show_button("Privacy Polcy", "", nil, privacy_url)
  stop_thread

end
def listen_for_start_postback
  bind 'START' do
    begin
      true ? for_team_ad : location
    rescue NoMethodError => e
      puts "Error => #{e.inspect}"
      stop_thread
    end
  end
end

def location
  sweepy = Sweep::User.find_or_create(user.id)
  say "Welcome to The Budweiser Sweep, #{sweepy.first_name} 🏀️!"
  # Sweep::User.find(postback.referral.ref).update_referral(sweepy.facebook_uuid) if postback.referral && postback.referral.ref.to_i != 0
  say "Please confirm your location by tapping 'Send Location' below 📍", quick_replies: LOCATION_PROMPT
  next_command :handle_lookup_location
end

def for_team_ad
  sweepy = Sweep::User.find_or_create(user.id)
  say "Welcome to the Knicks edition of The Budweiser Sweep, Nick 🏀️!"
  say "Please confirm that you're over 21 below 👇", quick_replies: ["Yes, I'm over 21", "No, I'm under 21"]
  next_command :over_21
end

def over_21
  if message.quick_reply == "YES, I'M OVER 21"
    say "Got it! So here's how it works:\n\n1. 🏀️ I'll send you 3 plays every day the Knicks are on the court\n2. ☝️ Make 3 predictions\n3. 🏆 Get all 3 right and earn your way into the Budweiser Final (I'll remind you 😎)\n4. 🎉 Win some crazy, unforgettable Knicks experiences from Budweiser"
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/event?loader"
    show_button("PICK NOW 🏀️", " Ready to make your 3 picks? Tap below 👇", nil, url)
    stop_thread
  else
    say "I'm sorry, you are ineligible to participate 👋"
    stop_thread
  end
end
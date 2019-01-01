require 'hash_dot'
GOOGLE_MAPS_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.freeze

def start
  bind 'START' do
    begin
      if postback.referral
        for_team_ad(postback.referral.ref.split("_")[-1])
      else
        location
      end
    rescue NoMethodError => e
      puts "Error => #{e.inspect}"
      stop_thread
    end
  end
end

def location
  sweepy = Sweep::User.find_or_create(user.id)
  say "Welcome to The Budweiser Sweep, #{sweepy.first_name} 🏀️!"
  say "We have a few qualifying NBA teams to choose from. Give us a city and we'll find the closest matching team to get started with 📍"
  next_command :handle_lookup_location
end

def handle_lookup_location
  response = $wit.message(message.text).to_dot
  coords = response.entities.location[0].resolved.values[0][0].coords
  puts "COORDS => #{coords.inspect}"
  # lat, long = coords.lat, coords.long
  # parsed = get_parsed_response(GOOGLE_MAPS_API_URL, "#{lat},#{long}")
  # address = extract_full_address(parsed)
  say "You chose #{message.text}, which qualifies you for the San Antonio Spurs Sweep! Ready to play?"
  stop_thread
end

def get_parsed_response(url, query)
  response = HTTParty.get(url + query)
  parsed = JSON.parse(response.body)
  parsed['status'] != 'ZERO_RESULTS' ? parsed : nil
end

def extract_full_address(parsed)
  parsed['results'].first['formatted_address']
end

def for_team_ad(owner_id)
  sweepy = Sweep::User.find_or_create(user.id)
  say "Welcome to the Knicks edition of The Budweiser Sweep, Nick 🏀️!"
  puts "Ref => #{postback.referral.ref}"
  say "Please confirm that you're over 21 below 👇", quick_replies: ["Yes, I'm over 21", "No, I'm under 21"]
  next_command :over_21
end

def over_21
  if message.quick_reply == "YES, I'M OVER 21"
    say "Got it! So here's how it works:\n\n1. 🏀️ I'll send you 3 plays every day the Knicks are on the court\n2. ☝️ Make 3 predictions\n3. 🏆 Get all 3 right and earn your way into the Budweiser Final (I'll remind you 😎)\n4. 🎉 Win some crazy, unforgettable Knicks experiences from Budweiser"
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard"
    show_button("PICK NOW 🏀️", " Ready to make your 3 picks? Tap below 👇", nil, url)
    stop_thread
  else
    say "I'm sorry, you are ineligible to participate 👋"
    stop_thread
  end
end
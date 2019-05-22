require 'hash_dot'
require 'httparty'

def start
  bind 'START' do
    begin
      if postback.referral
        team = postback.referral.ref.split('_').map(&:capitalize).join(' ').split('?')[0]
        param_key = postback.referral.ref.split('?')[-1].split('=')[0]
        param_value = postback.referral.ref.split('?')[-1].split('=')[1]
        if param_key == "source"
          sweepy = Sweep::User.find_or_create(user.id, team: team, source: param_value)
        else
          sweepy = Sweep::User.find_or_create(user.id, team: team)
        end
        intro = "Welcome to the Budweiser Sweep #{sweepy.first_name}!"
        disclaimer = "Please note that you need to be of legal drinking age to enter."
        say "#{intro}\n\n#{disclaimer}\n\n"
        sleep 0.5
        img_url = sweepy.roles.first.team_entry_image
        image = UI::ImageAttachment.new(img_url)
        show(image)
        body_one = "The Budweiser Sweep you’ve entered will feature questions from the #{sweepy.roles.last.team_name}."
        body_two = "This is a game to test your ability to answer questions correctly about what’s going to happen for every #{sweepy.roles.last.team_name} game this season."
        body_three = "You’ll definitely want to answer these, as we’re giving away some cool #{sweepy.roles.last.team_name} prizes all season long."
        say "#{body_one}\n\n#{body_two}\n\n#{body_three}"
        confirmation_text = "First, we need to confirm a few details so you can collect your prizes when you win!"
        url = "#{ENV['WEBVIEW_URL']}/#{user.id}/account"
        show_button("Confirm NOW 💥", confirmation_text, nil, url)
      else
        sweepy = Sweep::User.create(user.id, team)
        intro = "Welcome to the Budweiser Sweep!"
        disclaimer = "Please note that you need to be of legal drinking age to enter."
        body = "The Budweiser Sweep game is your chance to predict the future this baseball season - answer three questions about baseball games for your chance to win exclusive prizes."
        say "#{intro}\n\n#{disclaimer}\n\n#{body}"
        confirmation_text = "First, we need to confirm a few details so you can collect your prizes when you win!"
        url = "#{ENV['WEBVIEW_URL']}/#{user.id}/account"
        show_button("Confirm NOW 💥", confirmation_text, nil, url)
        stop_thread
      end
    rescue NoMethodError => e
      puts "Error => #{e.inspect}\n"
      puts "With User ID => #{user.id}"
    end
  end
end

def handle_lookup_location
  response = $wit.message(message.text).to_dot
  if response.entities.keys.first == "location"
    coords = response.entities.location[0].resolved.values[0][0].coords
    puts "COORDS => #{coords.inspect}"
    # lat, long = coords.lat, coords.long
    # parsed = get_parsed_response(GOOGLE_MAPS_API_URL, "#{lat},#{long}")
    # address = extract_full_address(parsed)
    say "You chose #{message.text}, which qualifies you for the San Antonio Spurs Sweep! Ready to play?"
    next_command :ready
  else
    say "I couldn't figure out a location from that, try something like, 'Austin, TX' or 'Phoenix Arizona'"
    next_command :handle_lookup_location
  end
end

def ready
  response = $wit.message(message.text).to_dot
  puts "SURE RESPONSE => #{response.inspect}"
  if response.entities.any?
    entity = response.entities.sentiment
    if entity.first.value == "positive"
      say "Great! Lets do this!"
      say "Start typing stuff, I'm pretty smart and can respond accordingly..."
      stop_thread
    elsif entity.first.value == "neutral"
      say "You don't sound too excited, but thats ok. You will!"
      stop_thread
    else
      say "I'm sorry about that, but unfortunately that's the best option we have based on the location you gave us. If you want to try another city, we can do another lookup?"
      stop_thread
    end
  else
    say "I didn't catch that, but I'll assume you're good to go..."
    stop_thread
  end
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

def for_team_ad(referral_tag)
  sweepy = Sweep::User.find_or_create(user.id, referral_tag)
  puts "Referral Tag Passed => #{referral_tag}"
  puts "Postback Referral => #{postback.referral.ref}"
  stop_thread
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
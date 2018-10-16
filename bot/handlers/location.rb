module Commands
  API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.freeze

  # Lookup based on location data from user's device
  def handle_lookup_location
    if message_contains_location?
      handle_user_location
    else
      say("Please try your request again and use 'Send location' button")
    end
    stop_thread
  end

  def handle_user_location
    say "Great, I see you're in New York!"
    say "Confirm your favorite team by tapping below 👇", quick_replies: ["New York Knicks"]
    next_command :handle_team
  end

  def handle_team
    say "Got it!"
    say "Send quick overview and gif of how to play..."
    stop_thread
  end

  # Talk to API
  # def get_parsed_response(url, query)
  #   response = HTTParty.get(url + query)
  #   parsed = JSON.parse(response.body)
  #   parsed['status'] != 'ZERO_RESULTS' ? parsed : nil
  # end

  # def extract_full_address(parsed)
  #   parsed['results'].first['formatted_address']
  # end
end

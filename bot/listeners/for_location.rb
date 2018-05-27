def listen_for_location
  for_location
end

def for_location
  bind 'location', all: true, to: :handle_lookup_location, reply_with: {
     text: "Home sweet home 🏡",
     quick_replies: LOCATION_PROMPT
   }
end
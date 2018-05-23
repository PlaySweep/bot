def listen_for_location
  for_location
end

def for_location
  bind 'location', all: true, to: :lookup_location, reply_with: {
     text: 'Let me know your location',
     quick_replies: LOCATION_PROMPT
   }
end
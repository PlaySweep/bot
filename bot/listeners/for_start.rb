def listen_for_start_postback
  bind 'START' do
    begin
      sweepy = Sweep::User.find_or_create(user.id)
      say "Welcome to The Budweiser Sweep, #{sweepy.first_name}!"
      say "Thanks for adding me!\n\nPlease confirm your location by tapping 'Send Location' below 📍", quick_replies: LOCATION_PROMPT
      # Sweep::User.find(postback.referral.ref).update_referral(sweepy.facebook_uuid) if postback.referral && postback.referral.ref.to_i != 0
      next_command :handle_lookup_location
    rescue NoMethodError => e
      sweepy = Sweep::User.create(user.id)
      puts "Error => #{e.inspect}"
      stop_thread
    end
  end
end
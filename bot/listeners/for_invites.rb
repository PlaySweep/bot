def listen_for_invite_friends
  bind 'invite', 'share' do
    keywords = %w[invite share]
    msg = message.text.split(' ').map(&:downcase)
    matched = (keywords & msg)
    say INVITE_FRIENDS.sample
    show_invite
    stop_thread
  end
end

def listen_for_invite_friends_postback
  bind 'INVITE FRIENDS' do
    say INVITE_FRIENDS.sample
    show_invite
    stop_thread
  end
end
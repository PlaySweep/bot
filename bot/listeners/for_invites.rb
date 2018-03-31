def listen_for_invite_friends
  bind 'invite friends', 'share', 'invite', 'share with friends', 'share friends' do
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
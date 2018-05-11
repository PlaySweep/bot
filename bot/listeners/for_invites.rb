def listen_for_invite_friends
  bind 'invite friends', 'share', 'invite', 'share with friends', 'share friends' do
    $tracker.track(user.id, 'User Intended Referral', {'for' => 'Message'})
    short_wait(:message)
    say INVITE_FRIENDS.sample
    medium_wait(:message)
    show_invite
    stop_thread
  end
end

def listen_for_invite_friends_postback
  bind 'INVITE FRIENDS' do
    $tracker.track(user.id, 'User Intended Referral', {'for' => 'Postback'})
    short_wait(:postback)
    say INVITE_FRIENDS.sample
    medium_wait(:postback)
    show_invite
    stop_thread
  end
end
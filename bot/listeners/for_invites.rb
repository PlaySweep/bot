def listen_for_invite_friends
  bind 'invite friends', 'share', 'invite', 'share with friends', 'share friends' do
    @api = Api.new
    @api.fetch_user(user.id)
    $tracker.track(@api.user.id, 'User Intended Referral')
    short_wait(:postback)
    say INVITE_FRIENDS.sample
    medium_wait(:postback)
    show_invite
    stop_thread
  end
end

def listen_for_invite_friends_postback
  bind 'INVITE FRIENDS' do
    @api = Api.new
    @api.fetch_user(user.id)
    $tracker.track(@api.user.id, 'User Intended Referral')
    short_wait(:postback)
    say INVITE_FRIENDS.sample
    medium_wait(:postback)
    show_invite
    stop_thread
  end
end
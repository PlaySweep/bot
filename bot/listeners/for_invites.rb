def listen_for_invite_friends
  bind 'invite friends', 'share', 'invite', 'share with friends', 'share friends' do
    @api = Api.new
    @api.find_or_create('users', user.id)
    $tracker.track(@api.user.id, 'User Intended Referral')
    say INVITE_FRIENDS.sample
    show_invite
    stop_thread
  end
end

def listen_for_invite_friends_postback
  bind 'INVITE FRIENDS' do
    @api = Api.new
    @api.find_or_create('users', user.id)
    $tracker.track(@api.user.id, 'User Intended Referral')
    say INVITE_FRIENDS.sample
    show_invite
    stop_thread
  end
end
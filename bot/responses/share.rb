def trigger_invite
  say "Its easy to get your friends to play with you, just tap the share button below and they'll get an invite straight to their Messenger inbox 👍"
  show_invite
  stop_thread
end

def trigger_invite_postback
  bind 'INVITE FRIENDS' do
    say "Its easy to get your friends to play with you, just tap the share button below and they'll get an invite straight to their Messenger inbox 👍"
    show_invite
    stop_thread
  end
end
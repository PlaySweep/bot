def trigger_invite
  $tracker.track(user.id, 'User Intended Referral', {'for' => 'Message'})
  say "Its easy to get your friends to play with you, just tap the share button below and they'll get an invite straight to their Messenger inbox 👍"
  show_invite
  stop_thread
end
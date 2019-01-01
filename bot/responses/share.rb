def trigger_invite
  $tracker.track(user.id, 'User Intended Referral', {'for' => 'Message'})
  say "Just tap the share button below and your friend will get an invite in their Messenger inbox 👍"
  show_invite
  stop_thread
end
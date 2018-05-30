def listen_for_media
  if message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
    say "📷" and stop_thread and return if message.messaging['message']['attachments'][0]["type"] == 'image'
    say "🎥" and stop_thread and return if message.messaging['message']['attachments'][0]["type"] == 'video'
  end
end
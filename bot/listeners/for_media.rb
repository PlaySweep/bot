def listen_for_media
  if message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
    # message.messaging['message']['attachments'][0]["type"]
    stop_thread
  end
  stop_thread
end
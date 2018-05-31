def listen_for_media
  if message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
    image_options = ["📷", "Oh, that's pretty 📷"]
    video_options = ["🎥", "Nice clip 🎥"]
    say image_options.sample and stop_thread and return if message.messaging['message']['attachments'][0]["type"] == 'image'
    say video_options.sample and stop_thread and return if message.messaging['message']['attachments'][0]["type"] == 'video'
  end
end
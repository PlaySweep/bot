def listen_for_email
  for_email
end

def for_email
  bind 'Email me 💌', 'email', to: :entry_to_email, reply_with: {
     text: "Did I find the right one?\n\nIf you have another preference, you can type it in below 👇",
     quick_replies: EMAIL_PROMPT
   }
end
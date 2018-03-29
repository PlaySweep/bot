def redirect type
  #TODO make an api call to populate numemrous options
  case type
  when :start
    message.typing_on
    say "No time to waste, huh? I got you. Start making your picks by selecting a sport below 👇", quick_replies: [["NCAAB", "NCAAB"], ["NBA", "NBA"], ['MLB', 'MLB'], ["NHL", "NHL"]]
    stop_thread
  when :show_sports
    message.typing_on
    say "Whoops, did you need help making picks?", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  when :blow_steam
    message.typing_on
    say "You don't wanna blow steam anymore? Okaayyy", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  when :catch
    message.typing_on
    say "Ok lets get to it then", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  end
end
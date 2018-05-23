# def listen_for_dashboard
#   keywords = ['stats', 'dashboard', 'record']
#   msg = message.text.split(' ').map(&:downcase)
#   matched = (keywords & msg)
#   bind keywords, all: true, to: :entry_to_dashboard if matched.any?
# end

# def listen_for_dashboard_postback
#   bind 'DASHBOARD', to: :entry_to_dashboard_postback
# end
def listen_for_store
  stop_thread and return if message.text.nil?
  keywords = ['buy', 'lifeline', 'lifelines', 'protect', 'shield', 'item', 'items', 'purchases', 'purchase', 'product', 'products']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :handle_show_store if matched.any?
end

def listen_for_store_postback
  bind 'STORE' do
    handle_show_store
  end
end
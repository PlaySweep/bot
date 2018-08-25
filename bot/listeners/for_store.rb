def listen_for_store_postback
  bind 'STORE' do
    handle_show_store
  end
end
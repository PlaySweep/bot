def listen_for_login
  bind 'login', 'facebook' do
    show_login
  end
end
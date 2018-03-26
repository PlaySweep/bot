module Commands
  def dashboard
    @api = Api.new
    @api.find_or_create('users', user.id)
    message.typing_on
    say "I am cookin' up something special here 👩‍🍳"
    sleep 0.5
    message.typing_on
    say "I'll be the first to let you know when it's ready for show and tell 😊"
    stop_thread
  end
end
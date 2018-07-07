def listen_for_actions
  stop_thread and return if message.text.nil?
  for_lifeline
  for_challenge_response
end

def listen_for_actions_postback
  
end

def for_lifeline
  case message.text.downcase
  when 'use lifeline'
    @api = Api.new
    @api.fetch_user(user.id)
    keywords = ['lifeline', 'use lifeline']
    msg = message.text.split(' ').map(&:downcase)
    matched = (keywords & msg)
    if @api.user.data.sweep_coins >= 30
      if @api.user.daily.lifeline_used
        streak = @api.user.previous_streak
        text = "Use 30 Sweepcoins to revert to your previous streak of #{streak}?"
      else
        streak = find_best_streak(streaks: [@api.user.previous_streak, @api.user.daily.high_streak])
        text = "Use 30 Sweepcoins to revert to your best streak of #{streak}?"
      end
      bind keywords, to: :entry_to_lifeline, reply_with: {
        text: text,
        quick_replies: [["Yes 👍", "Yes Lifeline"], ["No 👎", "No Lifeline"]]
      } if matched.any?
    else
      bind keywords, to: :entry_to_not_enough_for_lifeline, reply_with: {
        text: "You don't have enough for a lifeline, but inviting or challenging friends can earn you more!",
        quick_replies: ["Invite friends", "Earn coins"]
      } if matched.any?
    end
  when 'lifeline'
    @api = Api.new
    @api.fetch_user(user.id)
    keywords = ['lifeline', 'use lifeline']
    msg = message.text.split(' ').map(&:downcase)
    matched = (keywords & msg)
    if @api.user.data.sweep_coins >= 30
      if @api.user.daily.lifeline_used
        streak = @api.user.previous_streak
        text = "Use 30 Sweepcoins to revert to your previous streak of #{streak}?"
      else
        streak = find_best_streak(streaks: [@api.user.previous_streak, @api.user.daily.high_streak])
        text = "Use 30 Sweepcoins to revert to your best streak of #{streak}?"
      end
      bind keywords, to: :entry_to_lifeline, reply_with: {
        text: text,
        quick_replies: [["Yes 👍", "Yes Lifeline"], ["No 👎", "No Lifeline"]]
      } if matched.any?
    else
      bind keywords, to: :entry_to_not_enough_for_lifeline, reply_with: {
        text: "You don't have enough for a lifeline, but inviting or challenging friends can earn you more!",
        quick_replies: ["Invite friends", "Earn coins"]
      } if matched.any?
    end
  end
end

def for_challenge_response
  keywords = ['accept', 'decline', 'confirm', 'pending']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :entry_to_challenge_response if matched.any?
end
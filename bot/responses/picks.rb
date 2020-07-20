require 'possessive'

def check_confirmed_and_fetch_picks
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.confirmed
    fetch_picks
  else
    account_confirmation
  end
end

def fetch_picks
  handle_show_sports
end

def handle_show_sports
  
  quick_replies = [{content_type: :text, title: "Share", payload: "SHARE"}]
  show_carousel(elements: picks_elements, quick_replies: quick_replies)
  stop_thread
  
end

def picks_elements
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.current_team
    contest_copy = sweepy.copies.find { |copy| copy.category == "Contest Subtitle" }
    interpolated_contest_copy = contest_copy.message % { team_abbreviation: sweepy.current_team.abbreviation }
    [
      {
        title: "#{sweepy.current_team.abbreviation.possessive} Contests",
        image_url: sweepy.current_team.entry_image,
        subtitle: interpolated_contest_copy,
        buttons: [
          {
            type: :web_url,
            url: "#{ENV['WEBVIEW_URL']}/messenger/#{sweepy.facebook_uuid}",
            title: "More contests",
            webview_height_ratio: :full,
            webview_share_button: :hide,
            messenger_extensions: true
          }
        ]
      }
    ]
  end
end
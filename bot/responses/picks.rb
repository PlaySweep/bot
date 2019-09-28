require 'possessive'

def fetch_picks
  handle_show_sports
end

def handle_show_sports
  message.typing_on
  quick_replies = [{content_type: :text, title: "Status", payload: "STATUS"}, {content_type: :text, title: "Share", payload: "SHARE"}]
  show_carousel(elements: picks_elements, quick_replies: quick_replies)
  stop_thread
  message.typing_off
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
            url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{sweepy.slug}/1",
            title: "More contests",
            webview_height_ratio: :full,
            messenger_extensions: true
          },
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{sweepy.slug}/2",
            title: "See results",
            webview_height_ratio: :full,
            messenger_extensions: true
          }
        ]
      }
    ]
  end
end
def build_payload_for resource, data
  case resource
  when 'users'
    data.map(&:full_name).first(4).each_slice(1).to_a.each_with_index do |user, index|
      user.push("#{data[index].full_name} #{data[index].facebook_uuid}")
    end
  when 'matchup'
    
  end
end

def build_custom_message challenge
  case challenge.name
  when 'Most Wins'
    "wants to challenge you on who will have the most wins in the span of #{challenge.duration_details.days} days!\n\nThe challenge duration will begin once you hit accept 👍"
  when 'Matchup'
    "wants to challenge you to take the Bills against the spread at (-4) against the Ravens (+4)\n\nTap select to accept 👍"
  end
end
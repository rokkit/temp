json.skills @skills do |skill|
  json.partial! '/api/v1/skills/skill', skill: skill, user_skills: @user_skills
end
json.achievements @achievements do |achievement|
  json.partial! '/api/v1/achievements/achievement', achievement: achievement
end
json.penalties @penalties do |penalty|
  json.extract! penalty, :id, :name, :slug, :description
  json.image request.protocol + request.host_with_port + penalty.image_url
  json.has penalty.has?(@user.id, @penalties_users)
end
json.bonuses @bonuses do |bonus|
  json.extract! bonus, :id, :name, :slug, :description
  json.image request.protocol + request.host_with_port + bonus.image_url
  json.has bonus.has?(@user.id, @bonuses_users)
end

json.works @works do |work|
  json.partial! '/api/v1/works/work', work: work
end

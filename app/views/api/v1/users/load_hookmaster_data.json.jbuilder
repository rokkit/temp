json.skills @skills do |skill|
  json.partial! '/api/v1/skills/skill', skill: skill, user_skills: @user_skills
end
json.achievements @achievements do |achievement|
  json.partial! '/api/v1/achievements/achievement', achievement: achievement
end
json.penalties @penalties do |penalty|
  json.extract! penalty, :id, :name, :image_url, :slug, :description
  json.has @penalties_users.pluck(:id).include?(penalty.id)
end
json.bonuses @bonuses do |bonus|
  json.extract! bonus, :id, :name, :image_url, :slug, :description
  json.has @bonuses_users.pluck(:id).include?(bonus.id)
end

json.works @works do |work|
  json.partial! '/api/v1/works/work', work: work
end

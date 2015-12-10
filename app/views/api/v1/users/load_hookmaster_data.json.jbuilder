json.skills @skills do |skill|
  json.partial! '/api/v1/skills/skill', skill: skill, user_skills: @user_skills
end
json.achievements @achievements do |achievement|
  json.partial! '/api/v1/achievements/achievement', achievement: achievement
end
json.penalties @penalties do |penalty|
  json.extract! penalty, :id, :name, :image_url, :slug, :description
end

json.bonuses @bonuses do |bonus|
  json.extract! bonus, :id, :name, :image_url, :slug, :description
end

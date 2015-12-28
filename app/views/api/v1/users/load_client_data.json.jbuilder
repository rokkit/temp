json.user do
  json.partial! 'user', user: @user
end
json.skills @skills do |skill|
  json.partial! '/api/v1/skills/skill', skill: skill, user_skills: @user_skills
end
json.achievements @achievements do |achievement|
  json.partial! '/api/v1/achievements/achievement', achievement: achievement
end

json.lounges @lounges do |lounge|
  json.extract! lounge, :id, :title
  json.tables lounge.tables do |table|
    json.extract! table, :id, :title
  end
end
json.users User.clients.order(:name).where('level <= ?', @user.level).where.not(id: @user.id) do|user|
  json.extract! user, :id, :name, :experience, :level
end
json.payments @payments do |payment|
  json.extract! payment, :id, :amount, :created_at
  json.lounge payment.table.lounge.title
  json.color payment.table.lounge.color
end

json.meets @meets do|meet|
  res = meet.reservation
  json.id meet.id
  json.status meet.status
  json.visit_date res.visit_date
  json.end_visit_date res.end_visit_date
  json.created_at res.created_at
  json.lounge do
    json.id res.table.lounge.id
    json.title res.table.lounge.title
    json.color res.table.lounge.color
  end
  json.owner do
    json.extract! meet.reservation.user, :id, :name, :experience, :level
  end
  json.users meet.reservation.meets do |meet|
    json.extract! meet.user, :id, :name, :experience, :level
  end
end

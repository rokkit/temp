json.extract! user, :id, :name, :phone, :auth_token, :employe, :work_company, :hobby, :role, :freezed, :confirmed_at, :birthdate, :skill_point
json.avatar user.avatar_url
json.achievements user.achievements do |a|
  json.id a.id
  json.name a.name
end

json.skills user.skills do |s|
  json.id s.id
  json.name s.name
end
if user.role == 'hookmaster'
  json.penalties user.penalties do |s|
    json.id s.id
    json.name s.name
    json.description
  end
  json.lounge_id user.lounge_id
else
  json.reservations user.reservations do |res|
    json.id res.id
    json.visit_date res.visit_date
    json.created_at res.created_at
    json.lounge do
      json.id res.table.lounge.id
      json.title res.table.lounge.title
      json.color res.table.lounge.color
    end
  end
end

json.city user.city || ''
json.country user.country || ''

json.exp user.total_experience
json.level user.current_level
json.need_to_levelup user.need_to_levelup
json.percents_exp user.percents_exp

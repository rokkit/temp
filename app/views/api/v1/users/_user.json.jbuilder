json.extract! user, :id, :name, :phone, :auth_token, :city, :employe, :work_company, :hobby, :role, :email
json.avatar user.avatar_url
json.achievements user.achievements do |a|
  json.id a.id
  json.name a.name
end
json.skills user.skills do |s|
  json.id s.id
  json.name s.name
end

json.penalties user.penalties do |s|
  json.id s.id
  json.name s.name
  json.description
end

json.exp user.total_experience
json.level user.current_level
json.need_to_levelup user.need_to_levelup


json.visits [] #user.visits do |visit|
#   json.id visit['_idrref']
#   json.amount visit['_fld1574']
#   json.lounge 'Либерти'
# end

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

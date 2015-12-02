json.extract! user, :id, :name, :phone, :auth_token
json.avatar user.avatar_url
json.achievements user.achievements do |a|
  json.id a.id
  json.name a.name
end
json.skills user.skills do |s|
  json.id s.id
  json.name s.name
end
json.exp user.total_experience
json.visits user.visits do |visit|
  json.id visit['_idrref']
  json.amount visit['_fld1574']
  json.lounge 'Либерти'
end

json.extract! @user, :id, :name, :phone, :auth_token
json.avatar @user.avatar_url
json.achievements @user.achievements do |a|
  json.id a.id
  json.name a.name
end

json.skills @user.skills do |s|
  json.id s.id
  json.name s.name
end

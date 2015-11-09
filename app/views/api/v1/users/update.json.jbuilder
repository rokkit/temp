json.extract! @user, :id, :name, :phone
  json.avatar @user.avatar_url
  json.achievements @user.achievements do |a|
    json.id a.id
    json.name a.name
  end

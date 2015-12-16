json.users_month @users_month do |user|
  json.partial! 'user_small', user: user
end
json.users_all_time @users_all_time do |user|
  json.partial! 'user_small', user: user
end

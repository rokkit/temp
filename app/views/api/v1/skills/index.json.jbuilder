user_skills = SkillsUsers.where(user_id: current_user.id)
json.array!(@skills) do |skill|
  json.partial! 'user', skill: skill, user_skills: user_skills
end

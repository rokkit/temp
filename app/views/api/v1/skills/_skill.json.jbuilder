json.extract! skill, :id, :name, :cost, :row, :description
json.image skill.image_url
json.parents SkillsLink.where(child_id: skill.id).pluck(:parent_id)

json.has user_skills.pluck(:skill_id).include?(skill.id)

if skill_user = user_skills.where(skill_id: skill.id).first
  json.taken_at skill_user.taken_at
  json.used_at skill_user.used_at
  if skill_user.used_at
    json.cooldown_used_at (skill_user.used_at + 1.month)
  else
    json.cooldown_used_at nil
  end
else
  json.taken_at nil
  json.used_at nil
end

has_parent_skill = (user_skills.pluck(:skill_id) & skill.parent_skills).present? || skill.parent_skills.empty?

has_enough_skill_points = current_user.skill_point >= skill.cost

can_parallel_take = false
if current_user.role == 'hookmaster'
  can_parallel_take = user_skills.includes(:skill).where(skills: {cost: skill.cost}).empty?
else
  can_parallel_take = true
end

if has_enough_skill_points && !current_user.skills.include?(skill) && has_parent_skill && can_parallel_take
  json.can_take true
else
  json.can_take false
end

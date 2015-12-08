json.array!(@skills) do |skill|
  json.extract! skill, :id, :name, :cost, :row, :description
  json.image skill.image_url
  json.parents SkillsLink.where(child_id: skill.id).pluck(:parent_id)
  json.has current_user.skills.pluck(:id).include?(skill.id)
  if skill_user = SkillsUsers.where(user_id: current_user.id, skill_id: skill.id).first
    json.taken_at skill_user.taken_at
  else
    json.taken_at nil
  end

  has_parent_skill = (current_user.skills.pluck(:id) & skill.parent_skills).present? || skill.parent_skills.empty?

  has_enough_skill_points = current_user.skill_point >= skill.cost
  if has_enough_skill_points && has_parent_skill
    json.can_take true
  else
    json.can_take false
  end
end

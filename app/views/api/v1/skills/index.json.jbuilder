json.array!(@skills) do |skill|
  json.extract! skill, :id, :name, :cost
  json.image skill.image_url
  json.parents SkillsLink.where(child_id: skill.id).pluck(:parent_id)
end

json.array!(@skills) do |skill|
  json.extract! skill, :id, :name
  json.image skill.image_url
  json.parent_id skill.parent_id
end

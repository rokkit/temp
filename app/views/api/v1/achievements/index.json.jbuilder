json.array!(@achievements) do |achievement|
  json.extract! achievement, :id, :name, :description
  json.image achievement.image_url
end

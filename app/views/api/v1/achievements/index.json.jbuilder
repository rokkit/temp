json.array!(@achievements) do |achievement|
  json.extract! achievement, :id, :name, :description
end

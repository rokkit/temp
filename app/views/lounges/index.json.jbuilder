json.array!(@lounges) do |lounge|
  json.extract! lounge, :id, :title, :city_id, :color
  json.blazon lounge.blazon_url
end

json.array!(@lounges) do |lounge|
  json.extract! lounge, :id, :title, :city_id, :color
  json.blazon request.protocol + request.host_with_port + lounge.blazon_url
  json.city lounge.city.name
end

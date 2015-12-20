json.extract! lounge, :id, :title, :city_id, :color, :slug, :lat, :lng, :work_hours
json.blazon request.protocol + request.host_with_port + lounge.blazon_url
json.city lounge.city.name
json.slogan lounge.slogan
json.slogan_ru lounge.slogan_ru
json.address lounge.address
json.phone lounge.phone
json.description_header lounge.description_header
json.description_text lounge.description_text
json.hookmasters_description lounge.hookmasters_description
json.map_district lounge.map_district
json.map_description lounge.map_description
json.vk_link lounge.vk_link
json.hookmasters  lounge.hookmasters do |hm|
  json.id hm.id
  json.name hm.name
  json.description hm.description
end
json.photos  lounge.photos do |l|
  json.image l.image_url
end

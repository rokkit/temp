json.id res.id
json.visit_date res.visit_date
json.end_visit_date res.end_visit_date
json.created_at res.created_at
json.status res.status
if res.meets.present?
  json.client_count res.meets.count + 1
else
  if res.client_count == 4
    json.client_count '1-4'
  else
    json.client_count '5-6'
  end
end
json.lounge do
  json.id res.table.lounge.id
  json.title res.table.lounge.title
  json.color res.table.lounge.color
end
json.meets res.meets do |meet|
  json.extract! meet.user, :id, :name, :experience, :level
  json.status meet.status
end

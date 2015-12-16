json.id res.id
json.visit_date res.visit_date
json.end_visit_date res.end_visit_date
json.created_at res.created_at
if res.meet.present?
  json.client_count res.meet.count
else
  if res.client_count == 2
    json.client_count '2-3'
  else
    json.client_count '4-5'
  end
end
json.lounge do
  json.id res.table.lounge.id
  json.title res.table.lounge.title
  json.color res.table.lounge.color
end
json.meets res.meets do |meet|
  json.extract! meet.user, :id, :name, :experience, :level
end

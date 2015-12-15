json.id res.id
json.visit_date res.visit_date
json.end_visit_date res.end_visit_date
json.created_at res.created_at
json.client_count res.client_count
json.lounge do
  json.id res.table.lounge.id
  json.title res.table.lounge.title
  json.color res.table.lounge.color
end
json.meets res.meets do |meet|
  json.extract! meet.user, :id, :name, :experience, :level
end

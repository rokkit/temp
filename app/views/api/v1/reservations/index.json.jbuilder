json.array!(@reservations) do |res|
  json.id res.id
  json.visit_date res.visit_date
  json.created_at res.created_at
  json.lounge do
    json.id res.table.lounge.id
    json.title res.table.lounge.title
    json.color res.table.lounge.color
  end
end

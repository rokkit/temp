json.lounges @lounges do |lounge|
  json.extract! lounge, :id, :title
  json.tables lounge.tables do |table|
    json.extract! table, :id, :title
  end
end
json.users User.clients.order(:experience) do|user|
  json.extract! user, :id, :name, :experience, :level
end
json.payments @payments do|payment|
  json.extract! payment, :id, :amount, :created_at
end

json.meets @meets do|meet|
  res = meet.reservation
  json.id meet.id
  json.status meet.status
  json.visit_date res.visit_date
  json.end_visit_date res.end_visit_date
  json.created_at res.created_at
  json.lounge do
    json.id res.table.lounge.id
    json.title res.table.lounge.title
    json.color res.table.lounge.color
  end
  json.owner do
    json.extract! meet.reservation.user, :id, :name, :experience, :level
  end
  json.users meet.reservation.meets do |meet|
    json.extract! meet.user, :id, :name, :experience, :level
  end
end

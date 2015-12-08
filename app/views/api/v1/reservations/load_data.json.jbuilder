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

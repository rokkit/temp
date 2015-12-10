json.extract! work, :id, :work_at, :end_work_at, :amount
json.lounge do
  json.id work.lounge.id
  json.title work.lounge.title
  json.color work.lounge.color
end

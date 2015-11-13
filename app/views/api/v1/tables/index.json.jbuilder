json.array!(@tables) do |table|
  json.extract! table, :id, :title, :seats
end

json.array!(@reservations) do |res|
  json.partial! 'reservation', res: res
end

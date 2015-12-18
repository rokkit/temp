json.array!(@lounges) do |lounge|
  json.partial! 'lounge', lounge: lounge
end

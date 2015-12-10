json.array!(@works) do |work|
  json.partial! 'work', work: work
end

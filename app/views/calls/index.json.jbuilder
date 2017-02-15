json.array!(@calls) do |call|
  json.extract! call, :id
  json.url call_url(call, format: :json)
end

json.array!(@teams) do |team|
  json.extract! team, :id, :name, :numbers, :members
  json.url team_url(team, format: :json)
end

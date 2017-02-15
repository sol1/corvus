json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :name
  json.url campaign_url(campaign, format: :json)
end

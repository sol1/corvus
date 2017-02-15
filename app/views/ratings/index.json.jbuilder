json.array!(@ratings) do |rating|
  json.extract! rating, :id, :rating, :created_at
  json.url rating_url(rating, format: :json)
  json.created_at_s rating.created_at.strftime('%d/%m %H:%M')
  json.author rating.user.shortname rescue ''
end

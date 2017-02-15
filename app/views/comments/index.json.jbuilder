json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :created_at
  json.url comment_url(comment, format: :json)
  json.created_at_s comment.created_at.strftime('%d/%m %H:%M')
  json.author comment.user.shortname rescue ''
end

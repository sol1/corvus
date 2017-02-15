json.extract! @rating, :id, :created_at, :updated_at

if @rating.user
	json.rater @rating.user.shortname
else
	json.rater 'unknown'
end
json.extract! @call, :id, :caller, :called, :callername
json.duration hms(@call.connect_duration)
json.datetime @call.calldate.strftime('%a %e %b %Y %H:%M')

if @call.rating
	json.rating @call.rating.rating
	json.rater @call.rating.user.shortname
else
	json.rating 0
end
	
json.wav_path wav_call_path(@call)
json.download_path download_call_path(@call)
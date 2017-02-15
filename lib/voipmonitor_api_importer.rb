require 'pp'

puts "Interpreter spinup complete, logging start time"
$start_time = Time.now
puts "Authenticating..."
$uri = URI.parse(Rails.application.config.voipmonitor[:baseurl])
# Different path needed for the CDR api
$uri.path = "/voipmonitor/php/model/sql.php"

#puts $uri.inspect

$http = Net::HTTP.new($uri.host, $uri.port)

# /php/model/sql.php?module=bypass_login&user=USERNAME&pass=PASSWORD
args = {
	module: 'bypass_login',
	user: Rails.application.config.voipmonitor[:user],
	pass: Rails.application.config.voipmonitor[:password]
}
$uri.query = URI.encode_www_form(args)
#puts $uri.inspect
resp, data = $http.get($uri)
$uri.query = nil
puts "Authentication complete at #{Time.now - $start_time} seconds"

# For SOME CRAZY ILLOGICAL REASON voipmonitor returns a 'set-cookie' header with a PHPSESSID that isn't the same as this one that it expects for auth
#puts "---- debug ----"
pp resp
#puts "---------------"
sid = JSON.parse(resp.body)['SID']
$cookie = "PHPSESSID=#{sid}"

def sync
	tally = 0
	synced = false
	step = 1000
	# Find the latest call we know about
	lastcall = Call.order(cdr_id: :desc).first
	startID = lastcall.blank? ? 0 : lastcall.cdr_id
	while synced == false do
		begin
			args = {
				task: 'LISTING',
				module: 'CDR',
				fdurationgt: 0,
			#	fdatefrom: '2015-05-28T10:00:00',
			#	fdateto: '2015-05-28T11:00:00',
				start: startID,
				limit: (step)
			}
			headers = {
				'Cookie' => $cookie
			}
			puts "Requesting..."
			resp, data = $http.post($uri, URI.encode_www_form(args), headers)
			puts "Request complete at #{Time.now - $start_time} seconds"
			data = JSON.parse(resp.body)
			puts "#{data["total"]} items available from API"
			puts "Our requested starting id: #{startID}"
			puts "#{data["results"].count} results in set"
			tally += data["results"].count
			endID = data["total"].to_i
			puts "Saving records..."
			for cdr in data["results"]
				update(cdr)
			end
			puts "Done saving"
			if data["results"].count < (step)
				synced = true
			else
				startID += step
			end
		rescue SystemExit, Interrupt
			raise
		rescue Exception => e
			puts e.message
		end
		puts "total items synced: #{tally}"
	end
end

def duration_to_seconds(dur)
	elements = dur.split(":").count
	#mocktime = ""
	#timeformat = ""
	case elements
	when 2
		m,s = dur.split(":")
		duration = (m.to_i * 60) + s.to_i
		#print "#{duration}s, "
		return duration
	#	timeformat = "%M:%S"
	#	mocktime = Time.strptime "00:00", timeformat
	# when 3
	# 	puts "?"
	# 	raise TimeError
	# 	#timeformat = "%H:%M:%S"
	# 	#mocktime = Time.strptime "00:00:00", timeformat
	else
		puts "Invalid time format encountered, returning 0"
		return 0
	end
end

def update(cdr)
	timeformat = "%Y-%m-%d %H:%M:%S" #2014-12-08 08:19:29
	inb = InboundNumber.find_or_create_by(number: cdr["called"]) do |inb|
		inb.label = ''
	end
	calldetail = Call.unscoped.find_or_create_by(cdr_id: cdr["cdr_ID"].to_i) do |newcdr|
		#cdr.cdr_id
		newcdr.calldate = DateTime.strptime(cdr['calldate'], timeformat)
		newcdr.callend = DateTime.strptime(cdr['callend'], timeformat)
		newcdr.duration = duration_to_seconds(cdr['duration'])
		newcdr.connect_duration = duration_to_seconds(cdr['connect_duration'])
		newcdr.caller = cdr['caller']
		newcdr.callername = cdr['callername']
		newcdr.called = inb
		newcdr.whohanged = cdr['whohanged']
		newcdr.bye = cdr['bye']
		newcdr.last_sip_response = cdr['lastSIPresponse']
		newcdr.last_sip_response_num = cdr['lastSIPresponseNum']
		newcdr.id_sensor = cdr['id_sensor']
	end
end

sync

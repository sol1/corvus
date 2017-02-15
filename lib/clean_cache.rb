
begin
	config = Rails.application.config.voipmonitor_cache_cleaner
rescue Exception => e
	puts "\nError reading configuration - is config.voipmonitor_cache_cleaner defined in your environment?\n\n\t(#{e.message})\n\n"
	exit
end

include ActionView::Helpers::NumberHelper

now = Time.now
usage_size = 0
deleted_size = 0
entries = []

def humanize secs
	[[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
		if secs > 0
			secs, n = secs.divmod(count)
			if n > 0
				"#{n.to_i} #{name}"
			end
		end
	}.compact.reverse.join(' ')
end

puts "Scanning cache directory..."
Dir.foreach(config[:tmpdir]) {
	|ent|
	if File.file? config[:tmpdir].join(ent)
		s = File.stat(config[:tmpdir].join(ent))
		entries << {:name => config[:tmpdir].join(ent), :stat => s}
		usage_size += s.size
	end
}

entries.sort! {
	|a,b|
	a[:stat].mtime <=> b[:stat].mtime
}
puts "Current disk usage:\t#{number_to_human_size usage_size}"

entries.each {
	|ent|
	# Flag all entries older than max_age
	old = ent[:stat].mtime + config[:max_age] < now
	# Flag entries for as long as current usage exceeds max_size
	large = (usage_size - deleted_size) > config[:max_size]
	# Flag entries if we've started deleting due to exceeding max_size but have not yet reached the free_size threshold
	threshold = usage_size > config[:max_size] ? ((usage_size - deleted_size) > (config[:max_size] - config[:free_size])) : false
	if old || large || threshold
		print "Deleting #{ent[:name]}"
		if old
			puts "\tReason: Older than maximum age"
		elsif large
			puts "\tReason: Cache larger than maximum size"
		else
			puts "\tReason: Freed space is not yet below threshold"
		end
		begin
			File.delete ent[:name]
			deleted_size += ent[:stat].size
		rescue Exception => e
			puts e.message
		end
	end
}

puts "Freed space:\t#{number_to_human_size deleted_size}"
puts "New disk usage:\t#{number_to_human_size usage_size - deleted_size} of #{number_to_human_size config[:max_size]} permitted"

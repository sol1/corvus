class Campaign < ActiveRecord::Base

	validates_presence_of :name

	has_many :number_ranges, :class_name => "CampaignNumberRange", :foreign_key => :parent_id

	# Get primary key of InboundNumbers in this campaign's number ranges as an array
	#
	def all_numbers
		out = []
		self.number_ranges.each do |r|
			(r.start..r.end).each do |n|
				if inb = InboundNumber.where(:number => n).first
					out.push(inb.id)
				end
			end
		end
		return out
	end

	def call_count(date_from=nil, date_to=nil)
		@calls = Call.unscoped.where('connect_duration > 0').where(:called_id => self.all_numbers)
		if date_from
			@calls = @calls.where('calldate >= ?', "#{date_from} 00:00:00")
		end
		if date_to
			@calls = @calls.where('calldate <= ?', "#{date_to} 23:59:59")
		end
		@calls.count()
	end

	# Return an associative array suitable for a graph of the number
	# of inbound calls to campaign numbers for the specified dates
	#
	def self.campaign_breakdown_graph(date_from=nil, date_to=nil)
		@graph_series = []
		Campaign.all.each do |campaign|
			@graph_series << [ campaign.name, campaign.call_count(date_from, date_to) ]
		end
		@graph_series
	end
end

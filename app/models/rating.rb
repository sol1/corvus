class Rating < ActiveRecord::Base

	belongs_to :call
	belongs_to :user

	validates_presence_of :rating, :user_id, :call_id

	before_save :store_call_info

	private
	def store_call_info
		self.calldate = self.call.calldate
	end

	def self.rating_breakdown_graph(date_from=nil, date_to=nil)
		@graph_series = []
		@ratings = Rating.where("rating IS NOT NULL")
		if date_from
			@ratings = @ratings.where('calldate >= ?', "#{date_from} 00:00:00")
		end
		if date_to
			@ratings = @ratings.where('calldate <= ?', "#{date_to} 23:59:59")
		end

		@ratings.group(:rating).count().each do |rating,count|
			@graph_series << [ "#{rating} stars", count ]
		end
		@graph_series
	end
end

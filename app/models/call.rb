class Call < ActiveRecord::Base
	
	belongs_to :called, :class_name => 'InboundNumber'
	has_many :comments
	has_one :rating

	class << self
		attr_accessor :current_user
	end

	default_scope {
		number_filters = []
		if @current_user
			if @current_user.team && !@current_user.team.number_ranges.blank?
				@current_user.team.number_ranges.each do |nr|
					for n in nr.start .. nr.end
						inb = InboundNumber.where(:number => n.to_s).first
						if !inb.blank?
							number_filters << " called_id = #{inb.id} OR caller = '#{n.to_s}' "
						end
					end
				end
				number_filter = number_filters.join(' OR ')
			else
				# No results if normal user, all results if manager
				number_filter = "false" unless @current_user.manager
			end
		end
		order('calldate DESC').where('connect_duration > 0').where(number_filter)
	}

	def self.set_current_user user
		@current_user = user
		return self
	end

	def comment_text
		if self.comments.any?
			return self.comments.first.content
		end
		return ''
	end
end

class Team < ActiveRecord::Base
	has_many :users
	has_many :number_ranges, :class_name => "TeamNumberRange", :foreign_key => :parent_id
end

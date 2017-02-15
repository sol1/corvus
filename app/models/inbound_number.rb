class InboundNumber < ActiveRecord::Base
	has_many :calls, foreign_key: :called_id
end

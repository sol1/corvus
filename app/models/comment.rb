class Comment < ActiveRecord::Base

	belongs_to :call
	belongs_to :user

	validates_presence_of :content, :user_id, :call_id
end

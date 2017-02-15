class StatusCode < ActiveRecord::Base

	self.table_name = 'cdr_sip_response'
	self.primary_key = 'id'

	establish_connection "voipmonitor_#{Rails.env}".to_sym # external db

	def label
		self.lastSIPresponse
	end
end

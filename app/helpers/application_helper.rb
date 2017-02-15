module ApplicationHelper

	ALERT_TYPES = [:success, :info, :warning, :danger]
	
	def bootstrap_flash
		flash_messages = []
		flash.each do |type, message|
			# Skip empty messages, e.g. for devise messages set to nothing in a locale file.
			next if message.blank?

			type = type.to_sym
			type = :success if type == :notice
			type = :danger  if type == :alert
			type = :danger  if type == :error
			next unless ALERT_TYPES.include?(type)

			Array(message).each do |msg|
				text = content_tag(:div,
					content_tag(:button, raw("&times;"), 
										 :class => "close", 
										 "data-dismiss" => "alert",
										 "aria-hidden" => "true",
										 "type" => "button") +
					msg,
					:class => "alert fade in alert-#{type} alert-dismissable")
				flash_messages << text if msg
			end
		end
		flash_messages.join("\n").html_safe
	end
	
	def active_if_controller(slug)
		slugs = slug.split('|')
		if slugs.include? controller_name
			return 'active'
		end
	end

	# Render a duration in seconds as H:M:S
	def hms(seconds)
		Time.at(seconds).utc.strftime("%H:%M:%S")
	end
end

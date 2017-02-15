class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def authenticate_manager!
		# First, are we logged in at all?
		authenticate_user!

		# Is this user flagged as a manager in the db?
		if current_user.manager?
			return true
		else
			flash[:alert] = "Access denied."
			redirect_to "/" and return false
		end
	end
end

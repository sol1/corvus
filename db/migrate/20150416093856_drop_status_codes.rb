class DropStatusCodes < ActiveRecord::Migration
	# Turns out the voipmonitor db does have its own list
	def up
		drop_table :status_codes
	end

	def down
		create_table :status_codes do |t|
			t.string :code
			t.string :status
			t.string :description
	    end
	end
end

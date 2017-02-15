class MakeNumberRangesSti < ActiveRecord::Migration
	def up
		add_column :number_ranges, :type, :string, :limit => 32, :default => 'TeamNumberRange'
		
		execute "ALTER TABLE number_ranges DROP FOREIGN KEY `fk_rails_93fd82f142`;";
		rename_column :number_ranges, :team_id, :parent_id

		# Remove foreign key on number_ranges for team
		# remove_reference :number_ranges, :parent, index: true, foreign_key: true
	end

	def down
		remove_column :number_ranges, :type
		rename_column :number_ranges, :parent_id, :team_id
	end
end

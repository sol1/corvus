class CreateCacheCallStatsOnRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :calldate, :datetime
  end
end

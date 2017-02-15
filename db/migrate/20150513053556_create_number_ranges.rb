class CreateNumberRanges < ActiveRecord::Migration
  def change
    create_table :number_ranges do |t|
      t.references :team, index: true, foreign_key: true
      t.string :start
      t.string :end

      t.timestamps null: false
    end
  end
end

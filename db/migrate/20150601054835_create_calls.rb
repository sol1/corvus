class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :cdr_id, null: false
      t.datetime :calldate, index: true
      t.datetime :callend
      t.integer :duration
      t.integer :connect_duration
      t.string :caller
      t.string :callername
      t.integer :called_id, index: true
      t.string :whohanged
      t.integer :bye
      t.string :last_sip_response
      t.integer :last_sip_response_num
      t.integer :id_sensor

      t.timestamps null: false

    end
    add_index :calls, :cdr_id, unique: true
  end
end

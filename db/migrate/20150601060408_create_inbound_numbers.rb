class CreateInboundNumbers < ActiveRecord::Migration
  def change
    create_table :inbound_numbers do |t|
      t.string :number
      t.string :label

      t.timestamps null: false
    end
    add_index :inbound_numbers, :number, unique: true
    add_index :inbound_numbers, :label, unique: false
  end
end

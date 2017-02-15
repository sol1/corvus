class CreateStatusCodes < ActiveRecord::Migration
  def change
    create_table :status_codes do |t|
		t.string :code
		t.string :status
		t.string :description
    end
  end
end

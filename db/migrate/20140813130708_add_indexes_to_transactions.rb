class AddIndexesToTransactions < ActiveRecord::Migration
  def change
  	add_index :transactions, :user_id
  	add_index :transactions, :vendor_id
  	add_index :transactions, [:user_id, :vendor_id]
  end
end

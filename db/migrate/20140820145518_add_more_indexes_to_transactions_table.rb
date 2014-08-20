class AddMoreIndexesToTransactionsTable < ActiveRecord::Migration
  def change
  	add_index :transactions, [:product_id, :vendor_id]
  	add_index :transactions, [:product_id, :user_id]
  end
end

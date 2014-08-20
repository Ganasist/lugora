class RemoveDefaultForProductIdOnTransactions < ActiveRecord::Migration
  def change
  	change_column_default(:transactions, :product_id, nil)
  end
end

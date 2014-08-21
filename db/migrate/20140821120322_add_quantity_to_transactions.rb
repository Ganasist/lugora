class AddQuantityToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :quantity, :integer, default: 1
  end
end

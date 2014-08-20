class AddProductToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :product, index: true, null: false, default: 0
  end
end

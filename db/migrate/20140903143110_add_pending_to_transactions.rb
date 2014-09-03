class AddPendingToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :pending, :boolean, null: false, default: true
  end
end

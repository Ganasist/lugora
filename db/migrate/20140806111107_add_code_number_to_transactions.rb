class AddCodeNumberToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :code_position, :integer, null: false, default: 0
  end
end

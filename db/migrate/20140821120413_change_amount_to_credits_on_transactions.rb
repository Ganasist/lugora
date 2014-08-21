class ChangeAmountToCreditsOnTransactions < ActiveRecord::Migration
  def change
  	rename_column :transactions, :amount, :credits
  end
end

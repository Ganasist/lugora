class AddAmountAvailableToProducts < ActiveRecord::Migration
  def change
    add_column :products, :amount_available, :integer
  end
end

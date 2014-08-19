class AddPurchasesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :purchases, :integer, null: false, default: 0
  end
end

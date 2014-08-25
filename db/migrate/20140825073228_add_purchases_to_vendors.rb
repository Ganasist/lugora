class AddPurchasesToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :purchases, :integer, null: false, default: 0
  end
end

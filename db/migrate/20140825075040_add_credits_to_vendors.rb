class AddCreditsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :credits, :integer, null: false, default: 0
  end
end

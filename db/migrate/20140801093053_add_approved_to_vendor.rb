class AddApprovedToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :approved, :boolean, default: false, null: false
  end
end

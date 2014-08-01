class RemoveSecurityCodesFromVendors < ActiveRecord::Migration
  def change
    remove_column :vendors, :security_codes, :integer
  end
end

class AddSecurityCodesToUserAndVendor < ActiveRecord::Migration
  def change
    add_column :users, :security_codes, :integer, array: true, length: 144, default: []
    add_column :vendors, :security_codes, :integer, array: true, length: 144, default: []
  end
end

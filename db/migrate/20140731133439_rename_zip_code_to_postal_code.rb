class RenameZipCodeToPostalCode < ActiveRecord::Migration
  def change
  	rename_column :users, :zip_code, :postal_code
  	rename_column :vendors, :zip_code, :postal_code
  end
end

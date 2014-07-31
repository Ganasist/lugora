class RenameCountryCodeToCountryCallingCode < ActiveRecord::Migration
  def change
  	rename_column :users, :country_code, :phone_prefix
  	rename_column :vendors, :country_code, :phone_prefix
  end
end

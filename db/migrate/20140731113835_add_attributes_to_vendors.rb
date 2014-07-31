class AddAttributesToVendors < ActiveRecord::Migration
   def change
  	add_column :vendors, :first_name, :string
  	add_column :vendors, :last_name, :string
  	add_column :vendors, :business, :string
  	add_column :vendors, :country_code, :integer
  	add_column :vendors, :phone_number, :integer
  	add_column :vendors, :street_address, :string
  	add_column :vendors, :city, :string
  	add_column :vendors, :state, :string
  	add_column :vendors, :country, :string
  	add_column :vendors, :zip_code, :string
  end
end

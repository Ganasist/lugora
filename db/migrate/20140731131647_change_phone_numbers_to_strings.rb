class ChangePhoneNumbersToStrings < ActiveRecord::Migration
  def change
  	change_column :users, :phone_number, :string
  	change_column :vendors, :phone_number, :string
  	change_column :users, :country_code, :string
  	change_column :vendors, :country_code, :string
  end
end

class AddImageProcessingToUsersAndVendors < ActiveRecord::Migration
  def change
    add_column :users, :image_processing, :boolean, default: false
    add_column :vendors, :image_processing, :boolean, default: false
  end
end

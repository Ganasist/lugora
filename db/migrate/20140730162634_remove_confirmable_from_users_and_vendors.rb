class RemoveConfirmableFromUsersAndVendors < ActiveRecord::Migration
  def change
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :datetime
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :unconfirmed_email, :string

    remove_column :vendors, :confirmation_token, :string
    remove_column :vendors, :confirmed_at, :datetime
    remove_column :vendors, :confirmation_sent_at, :datetime
    remove_column :vendors, :unconfirmed_email, :string
  end
end

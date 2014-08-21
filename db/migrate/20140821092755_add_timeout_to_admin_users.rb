class AddTimeoutToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :timeout, :integer, null: false, default: 360
  end
end

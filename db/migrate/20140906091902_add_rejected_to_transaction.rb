class AddRejectedToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :rejected, :boolean, null: false, default: false
  end
end

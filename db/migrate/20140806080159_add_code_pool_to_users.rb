class AddCodePoolToUsers < ActiveRecord::Migration
  def change
    add_column :users, :code_pool, :integer, array: true, length: 144, default: []
  end
end

class AddUserIdIndexToUuid < ActiveRecord::Migration
  def change
  	add_index :uuid_credits, :user_id
  end
end

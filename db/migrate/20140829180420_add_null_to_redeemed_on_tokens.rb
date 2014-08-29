class AddNullToRedeemedOnTokens < ActiveRecord::Migration
  def change
  	change_column :tokens, :redeemed, :boolean, default: false, null: false
  end
end

class ChangeUsedToRedeemedInUuidCredits < ActiveRecord::Migration
  def change
  	rename_column :uuid_credits, :used, :redeemed
  end
end

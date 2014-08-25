class DropUuidCredits < ActiveRecord::Migration
  def change
  	drop_table :uuid_credits
  end
end

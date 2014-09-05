class AddPrintedToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :printed, :boolean, default: false, null: false
  end
end

class RenameTokenOnTokens < ActiveRecord::Migration
  def change
  	rename_column :tokens, :token, :encrypted_token
  end
end

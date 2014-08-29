class ChangeTokenToTokenCodeInTokens < ActiveRecord::Migration
  def change
  	rename_column :tokens, :encrypted_token, :encrypted_token_code
  end
end

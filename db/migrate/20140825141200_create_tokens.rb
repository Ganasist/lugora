class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :user, index: true
      t.string :token, null: false, unique: true
      t.integer :credits, null: false
      t.boolean :redeemed, default: false

      t.timestamps
    end
    add_index :tokens, :token, unique: true 
  end
end

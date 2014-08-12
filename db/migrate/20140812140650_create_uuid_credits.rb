class CreateUuidCredits < ActiveRecord::Migration
  def change
    create_table :uuid_credits do |t|
    	t.references :user, null: false
    	t.uuid 		:uuid, null: false
    	t.integer :credit, null: false
    	t.boolean :used, null: false, default: false

    	t.timestamps
    end
    add_index :uuid_credits, :uuid, unique: true
  end
end

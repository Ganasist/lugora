class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
    	t.references  :user,						null: false
    	t.references  :vendor,					null: false
    	t.integer			:security_code, 	null: false
    	t.integer 	  :amount,					null: false
    	t.boolean		 	:disputed,				default: nil
      t.timestamps
    end
  end
end

class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :credits
      t.belongs_to :vendor, index: true

      t.timestamps
    end
  end
end

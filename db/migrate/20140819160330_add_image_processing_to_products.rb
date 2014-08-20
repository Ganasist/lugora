class AddImageProcessingToProducts < ActiveRecord::Migration
  def change
    add_column :products, :image_processing, :boolean
  end
end

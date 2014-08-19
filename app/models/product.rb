class Product < ActiveRecord::Base
  belongs_to :vendor

  validates :name, :credits, :vendor_id, presence: true
  validates :credits, numericality: { only_integer: true }
end

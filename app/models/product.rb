class Product < ActiveRecord::Base
  include Attachments

  belongs_to :vendor
  has_many :transactions
  has_many :users, through: :transactions

  validates :name, :credits, :amount_available, :vendor_id, presence: true
  validates :credits, :amount_available, numericality: { only_integer: true }

  validates :amount_available, numericality: { greater_than_or_equal_to: 0, message: 'Product is no longer available!' }
end

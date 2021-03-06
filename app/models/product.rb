class Product < ActiveRecord::Base
  include Attachments
  
  acts_as_voteable

  belongs_to :vendor
  has_many :transactions
  has_many :users, through: :transactions

  validates :name, :credits, :amount_available, :vendor_id, presence: true
  validates :credits, :amount_available, numericality: { only_integer: true }

  validates :description, :location, length: { maximum: 255, message: 'This must be less than 256 characters!' }

  validates :amount_available, numericality: { greater_than_or_equal_to: 0, 
                                                                message: 'Product is no longer available!' }

  def self.vote(product, user, vote)
  	if user.products.include?(product) && !user.voted_on?(product)
			if vote == "upvote"
				user.vote_for(product)
			elsif vote == "downvote"
				user.vote_against(product)
			end					
		else
      self.errors[:base] << "You can't vote on this Product!"
			return false
		end
  end
end
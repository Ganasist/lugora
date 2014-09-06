class Transaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :vendor
	belongs_to :product

	# default_scope { order('created_at desc').limit(10) }

	scope :recent, -> { order('created_at desc').limit(10) }
	scope :pending, -> { where(pending: true) }
	scope :not_pending, -> { where(pending: false) }
	scope :paid, -> { where(paid: true) }
	scope :not_paid, -> { where(paid: false) }

	validates :user_id, :vendor_id, :product_id, :credits, :quantity, :security_code, :code_position, presence: true
	validates :credits, :security_code, :code_position, numericality: { only_integer: true }
	validates :security_code, length: { is: 6 }

	after_commit :deplete_user_code_pool, on: :create
	def deplete_user_code_pool
		self.user.code_pool.delete(self.code_position)
		self.user.code_pool_will_change!
		self.user.save!
	end

	after_commit :adjust_purchase_count, on: :create
	def adjust_purchase_count
		self.vendor.purchases 				+= self.quantity
		self.vendor.save!
		self.product.purchases 				+= self.quantity
		self.product.amount_available -= self.quantity
		self.product.save!
	end

	def unit_price
		credits / quantity
	end

	def purchase
		self.user.credits 	-= self.credits
		self.vendor.credits += self.credits
		begin
			ActiveRecord::Base.transaction do
				self.save!
				self.vendor.save!
				self.user.save!
			end
		rescue => e
			self.errors.add(:base, "Transaction failed!")
		end
	end

	def reject_transaction
		self.user.credits 						+= self.credits
		self.vendor.credits 					-= self.credits
		self.vendor.purchases 				-= self.quantity
		self.product.purchases 				-= self.quantity
		self.product.amount_available += self.quantity
		self.rejected 								= true
		self.pending 									= false
		begin
			ActiveRecord::Base.transaction do
				self.save!
				self.vendor.save!
				self.user.save!
			end
		rescue => e
			self.errors.add(:base, "Transaction rejection failed!")
		end
	end

	def self.search(input, query)
		input.transactions.where("created_at <= :q", q: "#{ query }")
	end	
end
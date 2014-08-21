class Transaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :vendor
	belongs_to :product

	default_scope { order('created_at desc').limit(10) }

	validates :user, :vendor, :product, :amount, :quantity, :security_code, :code_position, presence: true
	validates :amount, :security_code, :code_position, numericality: { only_integer: true }
	validates :security_code, length: { is: 6 }

	after_commit :deplete_user_code_pool, on: :create
	def deplete_user_code_pool
		self.user.code_pool.delete(self.code_position)
		self.user.code_pool_will_change!
		self.user.save!
	end

	after_commit :subtract_credits, on: :create
	def subtract_credits
		self.user.credits -= self.amount
		self.user.save!
	end

	def self.search(user, query)
		user.transactions.where("created_at <= :q", q: "#{ query }")
	end
end
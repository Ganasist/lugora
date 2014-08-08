class Transaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :vendor

	default_scope { order("created_at desc") }

	validates :user, :vendor, :amount, :security_code, :code_position, presence: true
	validates :amount, :security_code, :code_position, numericality: { only_integer: true }
	validates :security_code, length: { is: 6 }

	after_commit :deplete_user_code_pool, on: :create
	def deplete_user_code_pool
		self.user.code_pool.delete(self.code_position)
		self.user.code_pool_will_change!
		self.user.save!
	end
end
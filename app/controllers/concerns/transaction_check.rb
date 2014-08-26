class TransactionCheck
	def initialize(user, transaction)
		@user = user
		@transaction = transaction
	end

	def code_check?
		 code_available? && code_matches?    	 
	end

	def credit_check?
		@user.credits >= @transaction.credits
	end

	def product_check?
		@transaction.product.amount_available >= @transaction.quantity
	end

	def code_available?
		@user.code_pool.include?(@transaction.code_position)
	end

	def code_matches?
		(@user.security_codes.at(@transaction.code_position - 1) == 
			(@transaction.security_code))
	end
end
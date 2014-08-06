class TransactionCheck
	def initialize(user, transaction)
		@user = user
		@transaction = transaction
	end

	def check?
		@user.code_pool.include?(@transaction.code_position) &&
    	 (@user.security_codes.at(@transaction.code_position - 1) == 
    	 	(@transaction.security_code))
	end
end
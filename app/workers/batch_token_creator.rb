class BatchTokenCreator
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(token_quantity, credit_amount)
		if token_quantity.to_i.between?(100, 5000) && credit_amount.to_i >= 1000
		counter = 0
	  	while counter < token_quantity.to_i do
				token = Token.new(user_id: nil, 
				  							 redeemed: false, 
						 encrypted_token_code: SecureRandom.hex(8),
			     								credits: credit_amount.to_i )
	  		(token.save! && counter += 1) unless 
	  			(!token.valid? && Token.exists?(encrypted_token_code: token.encrypted_token_code))
		  end
		end
		return
  end
end
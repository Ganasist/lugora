class BatchTokenCreator
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(token_quantity, credit_amount)
		counter = 0
    
    def token_code
      loop do
        token_code = SecureRandom.hex(8)
        break token_code unless Token.exists?(encrypted_token_code: token_code)
      end
    end

  	while counter < token_quantity.to_i do
			token = Token.new(user_id: nil, 
			  							 redeemed: false, 
					 encrypted_token_code: token_code,
		     								credits: credit_amount.to_i )
  		(token.save! && counter += 1) unless !token.valid?
	  end
  end
end
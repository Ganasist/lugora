require 'faker'

Fabricator(:token) do
  user_id 								  { nil }
  encrypted_token_code 	    { SecureRandom.hex(8) }
  credits								    { %w(100 250 500 1000 2000 5000 10000).sample }
  redeemed									{ false }
end
100.times { Fabricate(:token) }
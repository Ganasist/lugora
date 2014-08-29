require 'faker'

Fabricator(:token) do
  user_id                   { nil }
  encrypted_token_code      { SecureRandom.hex(8) }
  credits                   { %w(100 250 500 1000 2000 5000 10000 25000 50000 100000).sample }
  redeemed                  { false }
end
1000.times { Fabricate(:token) }

# Fabricator(:user) do
#   first_name 								{ Faker::Name.first_name }
#   last_name 								{ Faker::Name.last_name }
#   occupation								{ Faker::Company.catch_phrase }
#   email											{ Faker::Internet.email }
#   phone_prefix							{ Faker::PhoneNumber.subscriber_number }
#   phone_number							{ rand(1000000..99999999) }
#   street_address						{ Faker::Address.street_address }
#   city											{ Faker::Address.city }
#   state											{ Faker::Address.state }
#   postal_code								{ Faker::Address.postcode }
#   password 									{ "loislane" }
#   password_confirmation 		{ |attrs| attrs[:password] }
# end
# 100.times { Fabricate(:user) }

# Fabricator(:vendor) do
#   first_name 								{ Faker::Name.first_name }
#   last_name 								{ Faker::Name.last_name }
#   business									{ Faker::Company.name }
#   email											{ Faker::Internet.email }
#   phone_prefix							{ Faker::PhoneNumber.subscriber_number }
#   phone_number							{ rand(1000000..99999999) }
#   street_address						{ Faker::Address.street_address }
#   city											{ Faker::Address.city }
#   state											{ Faker::Address.state }
#   postal_code								{ Faker::Address.postcode }
#   password 									{ "loislane" }
#   password_confirmation 		{ |attrs| attrs[:password] }
# end
# 100.times { Fabricate(:vendor) }

# Fabricator(:transaction) do
#   user                        { User.all.sample }
#   vendor                      { Vendor.all.sample }
#   amount                      { rand(100..100000) }
#   security_code               { rand(100000..999999) }
#   code_position               { rand(127) }
#   disputed                    { false }
#   created_at                  { Time.now - rand(1000).days - rand(1000).minutes }
# end
# 500.times { Fabricate(:transaction) }
require 'faker'

Fabricator(:user) do
  first_name 								{ Faker::Name.first_name }
  last_name 								{ Faker::Name.last_name }
  occupation								{ Faker::Company.catch_phrase }
  email											{ Faker::Internet.email }
  phone_prefix							{ Faker::PhoneNumber.subscriber_number }
  phone_number							{ Faker::PhoneNumber.phone_number.gsub(/[.]/i, '').to_i }
  street_address						{ Faker::Address.street_address }
  city											{ Faker::Address.city }
  state											{ Faker::Address.state }
  postal_code								{ Faker::Address.postcode }
  password 									{ "loislane" }
  password_confirmation 		{ |attrs| attrs[:password] }
end

Fabricator(:vendor) do
  first_name 								{ Faker::Name.first_name }
  last_name 								{ Faker::Name.last_name }
  business									{ Faker::Company.name }
  email											{ Faker::Internet.email }
  phone_prefix							{ Faker::PhoneNumber.subscriber_number }
  phone_number							{ Faker::PhoneNumber.phone_number.gsub(/[.]/i, '').to_i }
  street_address						{ Faker::Address.street_address }
  city											{ Faker::Address.city }
  state											{ Faker::Address.state }
  postal_code								{ Faker::Address.postcode }
  password 									{ "loislane" }
  password_confirmation 		{ |attrs| attrs[:password] }
end

100.times { Fabricate(:user) }
100.times { Fabricate(:vendor) }
class User < ActiveRecord::Base
	include Naming
  include Attachments
  include Scopes
  include Approval
  
  acts_as_voter

	has_many :transactions
	has_many :vendors, through: :transactions
	has_many :products, through: :transactions
	
	has_many :tokens
	accepts_nested_attributes_for :tokens

	scope :locked, -> { User.not(:unlocked) }

  devise :database_authenticatable, :registerable, :async, :confirmable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable

 	validates :first_name, :last_name,:occupation, :street_address, :phone_prefix,
 						:phone_number, :city, presence: true

 	validates :phone_prefix, :phone_number, :credits, numericality: { only_integer: true }

 	validates :credits, numericality: {	greater_than_or_equal_to: 0, 
 																					 						 message: 'Users cannot have negative credits!' }

 	# Security codes generated in SecurityCodesWorker
 	after_commit :generate_security_codes, on: :create
 	def generate_security_codes
 		SecurityCodeWorker.perform_async(self.id)
	end

	def timeout_in
    AdminUser.first.timeout
  end
end
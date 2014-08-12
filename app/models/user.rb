class User < ActiveRecord::Base
	include Naming

	has_many :transactions
	has_many :vendors, through: :transactions
	has_many :uuid_credits

	scope :not_approved, -> { where(approved: false) }
	scope :approved, -> { where(approved: true) }

  # Include default devise modules. Others available are:
  # :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :async,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable

 	validates :first_name, :last_name,:occupation, :street_address, :phone_prefix,
 						:phone_number, :city, presence: true

 	validates_numericality_of :phone_prefix, :phone_number

 	# Security codes generated in SecurityCodesWorker
 	after_commit :generate_security_codes, on: :create
 	def generate_security_codes
 		SecurityCodeWorker.perform_async(self.id)
	end
end
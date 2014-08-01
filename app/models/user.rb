class User < ActiveRecord::Base
	include Naming

	scope :not_approved, -> { where(approved: false) }
	scope :approved, -> { where(approved: true) }

  # Include default devise modules. Others available are:
  # :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable

 	validates :first_name, :last_name,:occupation, :street_address, :phone_prefix,
 						:phone_number, :city, :state, :postal_code, presence: true

 	validates_numericality_of :phone_prefix, :phone_number

 	# Security codes generated in SecurityCodes Concern file
 	after_commit :generate_security_codes, on: :create

 	def generate_security_codes
		self.security_codes = []
		random_array = (100000..999999).to_a.shuffle!
		codes = []
		144.times do
			code = random_array.slice!(0)
			codes.push(code)
		end
		self.update_column(:security_codes, codes)
	end
end
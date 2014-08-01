class Vendor < ActiveRecord::Base
	include Naming
	include SecurityCodes
  # Include default devise modules. Others available are:
  # :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :business, :street_address, :phone_prefix,
 						:phone_number, :city, :state, :postal_code, presence: true

	validates_numericality_of :phone_prefix, :phone_number

	# Security codes generated in SecurityCodes Concern file
 	after_commit :generate_security_codes, on: :create
end

class Vendor < ActiveRecord::Base
	include Naming
  # Include default devise modules. Others available are:
  # :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :business, :street_address, :phone_prefix,
 						:phone_number, :city, :state, :postal_code, presence: true

	validates_numericality_of :phone_prefix, :phone_number 
end

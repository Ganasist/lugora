class Vendor < ActiveRecord::Base
	include Naming

	has_many :transactions
	has_many :users, through: :transactions

	default_scope { order('created_at desc').limit(10) }

	scope :not_approved, -> { where(approved: false) }
	scope :approved, -> { where(approved: true) }
  
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable, :async, :confirmable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :business, :street_address, :phone_prefix,
 						:phone_number, :city, presence: true

	validates_numericality_of :phone_prefix, :phone_number

	def self.search(query)
		where("last_name @@ :q or first_name @@ :q", q: "%#{query}%")
	end
end

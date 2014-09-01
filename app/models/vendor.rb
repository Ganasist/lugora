class Vendor < ActiveRecord::Base
	include Naming
  include Attachments
  include Scopes
  include Approval

	has_many :products
	has_many :transactions
	has_many :users, through: :transactions

	scope :locked, -> { Vendor.not(:unlocked) }
  
  devise :database_authenticatable, :registerable, :async, :confirmable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :business, :street_address, :phone_prefix,
 						:phone_number, :city, presence: true

	validates_numericality_of :phone_prefix, :phone_number

	validates :url, url: { allow_blank: true, message: 'Please enter a correct URL including http://' }

	def self.search(query)
		where("business @@ :q", q: "%#{ query }%")
	end

	def timeout_in
    AdminUser.first.timeout
  end
end

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

 	validates :phone_prefix, :phone_number, :credits, numericality: { only_integer: true }

	validates :credits, numericality: { greater_than_or_equal_to: 0, 
																											messsage: 'Vendors cannot have negative credits!' }

	validates :phone_prefix, :phone_number, numericality: { only_integer: true }

	validates :url, url: { allow_blank: true, message: 'Please enter a correct URL including http://' }

	def self.search(query)
		where("business @@ :q", q: "%#{ query }%")
	end

	def timeout_in
    AdminUser.first.timeout
  end

  def cleared_credits
  	transactions.where('pending = ? AND paid = ?', nil, true).sum(:credits)
  end
end

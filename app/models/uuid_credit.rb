class UUID_Credit < ActiveRecord::Base
	belongs_to :user
	scope :not_redeemed, -> { where(redeemed: false) }
	scope :redeemed, -> { where(redeemed: true) }
 	validates :user, :uuid, presence: true
 	validates_numericality_of :credit
 	validates :uuid, uniqueness: true
end
class UUID_Credit < ActiveRecord::Base
	belongs_to :users
	scope :not_used, -> { where(used: false) }
	scope :used, -> { where(used: true) }
 	validates :user, :uuid, presence: true
 	validates_numericality_of :credit
 	validates :uuid, uniqueness: true
end
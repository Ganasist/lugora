class UUID_Credits < ActiveRecord::Base
	belongs_to :users
	scope :not_used, -> { where(used: false) }
	scope :used, -> { where(used: true) }
 	validates :user, :uuid, :credit, presence: true
 	validates_numericality_of :uuid, :credit
 	validates :uuid, uniqueness: true
end
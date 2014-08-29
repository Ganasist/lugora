class Token < ActiveRecord::Base
	attr_readonly :credits, :encrypted_token_code

  belongs_to :user
  attr_encrypted :token_code

  scope :redeemed, -> { where(redeemed: true) }
	scope :not_redeemed, -> { where(redeemed: false) }

  validates :encrypted_token_code, :credits, presence: true
  validates :credits, numericality: { only: :integer, greater_than: 0, message: 'Invalid token quantity' }
  validates_uniqueness_of :encrypted_token_code

  def self.verify(token, user)
		puts 'Token accepted!'
		token.user_id 	= user.id
		token.redeemed 	= true
		user.credits 		+= token.credits
		begin
		ActiveRecord::Base.transaction do
			token.save!
			user.save!
		end
			rescue => e
			puts 'Token transaction did failed!'
			# token.errors.add(:base, 'Token transaction failuress!!')
		end
  end
end
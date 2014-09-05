class Token < ActiveRecord::Base
	attr_readonly :credits, :encrypted_token_code, key: ENV['TOKEN_KEY']

  belongs_to :user
  attr_encrypted :token_code

  scope :redeemed, -> { where(redeemed: true) }
	scope :not_redeemed, -> { where(redeemed: false) }
	scope :not_redeemed_not_printed, -> { where(redeemed: false, printed: false)}

  validates :encrypted_token_code, :credits, presence: true
  validates :credits, numericality: { only: :integer,
  													  greater_than: 0, 
  													  		 message: 'Invalid token quantity' }
  validates_uniqueness_of :encrypted_token_code

  def self.process(token, user)
		puts 'Token accepted!'
		begin
		ActiveRecord::Base.transaction do
			token.user_id 	= user.id
			token.redeemed 	= true
			user.credits 		+= token.credits
			token.save!
			user.save!
		end
			rescue => e
			puts 'Token transaction did failed!'
			# token.errors.add(:base, 'Token transaction failuress!!')
		end
  end

  def self.generator_check?(quantity, value)
  	quantity.to_i.between?(100, 5000) && value.to_i >= 1000
  end
end
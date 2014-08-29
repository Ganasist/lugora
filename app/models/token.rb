class Token < ActiveRecord::Base
  belongs_to :user
  attr_encrypted :token_code

  validates :encrypted_token_code, :credits, presence: true
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
			puts 'Token transaction did succeeded!!'
		rescue => e
			puts 'Token transaction did failed!'
			token.errors.add(:base, 'Token transaction failed!')
		end
  end
end

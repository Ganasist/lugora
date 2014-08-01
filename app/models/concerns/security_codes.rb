#included in User, Vendor
module SecurityCodes
	extend ActiveSupport::Concern

	def generate_security_codes
		p "it works!"
	end
end
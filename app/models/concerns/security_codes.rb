#included in User, Vendor
module SecurityCodes
	extend ActiveSupport::Concern

	def generate_security_codes
		self.security_codes = []
		prefix = (100..999).to_a.shuffle!
		suffix = (100..999).to_a.shuffle!
		codes = []
		144.times do
			pre = prefix.slice!(0)
			suf = suffix.slice!(0)
			code = "#{pre}#{suf}"
			codes.push(code)
		end
		self.update_column(:security_codes, codes)
	end
end
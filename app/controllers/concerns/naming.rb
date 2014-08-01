# Included in User, Vendor
module Naming
	extend ActiveSupport::Concern
	def fullname
    if first_name? && last_name?
      "#{ first_name } #{ last_name }"
    else
      email
    end
  end
end
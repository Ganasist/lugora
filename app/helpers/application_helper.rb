module ApplicationHelper

	def name_truncate(item)
		if item.kind_of?(User)
			name = item.first_name
		elsif item.kind_of?(Vendor)
			name = item.business
		end
		name.truncate(13, separator: /\:print:/)
	end
end

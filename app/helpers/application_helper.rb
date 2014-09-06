module ApplicationHelper

	def name_truncate(item)
		if item.kind_of?(User)
			name = item.first_name
		elsif item.kind_of?(Vendor)
			name = item.business
		end
		name.truncate(14, separator: /\:print:/)
	end

	def transaction_show?
		params[:controller] == "transactions" && params[:action] == "show"
	end
end

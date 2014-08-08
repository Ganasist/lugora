module VendorsHelper
	def resource_name
    :vendor
  end

  def resource
    @resource ||= Vendor.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:vendor]
  end
end

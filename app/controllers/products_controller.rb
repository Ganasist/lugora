class ProductsController < ApplicationController
	before_action :set_vendor, only: [:new, :create]

	def new
		@product = Product.new
	end

	private
		def set_vendor
			@vendor = Vendor.find(params[:vendor_id])
		end
end

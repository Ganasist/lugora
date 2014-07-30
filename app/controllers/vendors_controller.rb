class VendorsController < ApplicationController
	# before_action :authenticate_vendor!

	def show
		@vendor = Vendor.find(params[:id])
	end

	private
		rescue_from ActiveRecord::RecordNotFound do |exception|
      if vendor_signed_in?
        redirect_to current_vendor
      else
        flash[:alert] = 'You need to sign in or sign up before continuing.'
        redirect_to root_url
      end
    end

end

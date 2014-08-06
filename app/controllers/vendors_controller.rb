class VendorsController < ApplicationController
	# before_action :authenticate_vendor!

  def index
    @vendors = Vendor.all  
  end

	def show
		@vendor = Vendor.find(params[:id])
	end

	private
		rescue_from ActiveRecord::RecordNotFound do |exception|
      if vendor_signed_in? || user_signed_in?
        flash[:alert] = 'Vendor does not exist'
        redirect_to current_vendor || current_user
      else
        flash[:alert] = 'You need to sign in or sign up before continuing.'
        redirect_to root_url
      end
    end
end

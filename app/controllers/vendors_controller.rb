class VendorsController < ApplicationController
	# before_action :authenticate_vendor!

  def index
    if params[:search] && params[:search] != ""
      @vendors = Vendor.search(params[:search]).order('created_at DESC')
    else
      @vendors = Vendor.all
    end
  end

	def show
		@vendor = Vendor.find(params[:id])
	end

	private
		rescue_from ActiveRecord::RecordNotFound do |exception|
      if vendor_signed_in? || user_signed_in?
        redirect_to current_vendor || current_user
      else
        flash[:alert] = 'You need to sign in or sign up before continuing.'
        redirect_to root_url
      end
    end
end

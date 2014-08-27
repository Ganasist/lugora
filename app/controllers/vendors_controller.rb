class VendorsController < ApplicationController

  def index
    if params[:search] && params[:search] != ""
      @vendors = Vendor.date_search(params[:search]) 
    else
      @vendors = Vendor.all
    end
  end

	def show
		@vendor = Vendor.find(params[:id])
    @products = @vendor.products
    if params[:search] && params[:search] != ""
      @date = params[:search].to_time.end_of_day
      @transactions = Transaction.date_search(@vendor, @date).limit(10).order('created_at DESC')
    else
      @transactions = @vendor.transactions
    end
	end

	private
		rescue_from ActiveRecord::RecordNotFound do |exception|
      if vendor_signed_in? || user_signed_in?
        flash[:alert] = "Vendor doesn't exist."
        redirect_to current_vendor || current_user
      else
        flash[:alert] = 'You need to sign in or sign up before continuing.'
        redirect_to root_url
      end
    end
end

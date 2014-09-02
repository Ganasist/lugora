class VendorsController < ApplicationController

  def index
    if params[:vendor_search] && params[:vendor_search] != ""
      @vendors = Vendor.search(params[:vendor_search]) 
    else
      @vendors = Vendor.recent.limit(10)
    end
  end

	def show
		@vendor = Vendor.find(params[:id])
    @products = @vendor.products
    if params[:transaction_search] && params[:transaction_search] != ""
      @date = params[:transaction_search].to_time.end_of_day
      if @date > Date.today + 1
        flash[:alert] = "You can't search for future transactions."
        redirect_to current_user
      else
        @transactions = Transaction.search(@vendor, @date).recent
      end      
    else
      @transactions = @vendor.transactions.includes(:product)
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

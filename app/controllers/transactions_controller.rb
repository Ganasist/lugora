class TransactionsController < ApplicationController
	before_action :depleted_code_pool
	before_action :new_transaction, only: [:new, :create]
	before_action :verify_transaction_owners, only: :show

	def index
	end

	def show
		@transaction = Transaction.find(params[:id])
		if user_signed_in?
			@user = User.find(params[:user_id])
		elsif vendor_signed_in?
			@vendor = current_vendor			
		end
	end

	def new
		@transaction  = Transaction.new
		@user 				= current_user
		@product 		  = Product.find(params[:product_id])
		@vendor 		  = @product.vendor
	end

	def create
    @transaction 					= Transaction.new(transaction_params)
    @product 							= Product.find(params[:product_id])
    @vendor 							= @product.vendor
    @transaction.product 	= @product
    @transaction.vendor  	= @vendor
    @transaction.user 		= current_user
    @transaction.credits	= @product.credits * @transaction.quantity

		if TransactionCheck.new(current_user, @transaction).check?
			if current_user.credits > @transaction.credits
		    respond_to do |format|
		      if @transaction.purchase
		        format.html { redirect_to user_transaction_path(current_user, @transaction), 
		        													notice: "Purchase successful! You have #{current_user.code_pool.length } security codes remaining." }
		        format.json { render action: 'show', status: :created, location: @transaction }
		      else
		        format.html { render action: 'new', error: 'Purchase failed. Please try again.' }
		        format.json { render json: @transaction.errors, status: :unprocessable_entity }
		      end
		    end
		   else
		   	flash[:error] = 'Insufficient credits. Please add more LINK HERE.'
	      render action: 'new'
		   end
	  else
	  	flash[:error] = 'You entered an incorrect security code'
      render action: 'new'
    end
	end

	def destroy
		
	end

	private
		rescue_from ActiveRecord::RecordNotFound do |exception|
      if vendor_signed_in? || user_signed_in?
        flash[:alert] = "Transaction doesn't exist."
        redirect_to current_vendor || current_user
      else
        flash[:alert] = 'You need to sign in or sign up before continuing.'
        redirect_to root_url
      end
    end

		def verify_transaction_owners
			@transaction = Transaction.find(params[:id])
			unless (user_signed_in? && current_user == @transaction.user) ||
						   (vendor_signed_in? && current_vendor == @transaction.vendor)
				flash[:error] = "You don't have access to that verification record."
				redirect_to current_user || current_vendor
			end
		end

		def new_transaction
			if current_vendor
				flash[:error] = 'You need to be logged in as a User to verify a transaction.'
				redirect_to current_vendor
			end
		end

		def depleted_code_pool
			if current_user && current_user.code_pool.length == 0
				flash[:error] = 'You have no more security codes remaining. Verifications unavailable.'
				redirect_to current_user
			end
		end

		def transaction_params
			params.require(:transaction).permit(:security_code, :code_position, :quantity)
		end
end
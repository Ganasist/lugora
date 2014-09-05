class TransactionsController < ApplicationController
	before_action :depleted_code_pool
	before_action :authenticate_user!, only: [:new, :create]
	# before_action :new_transaction, only: [:new, :create]
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

    tc = TransactionCheck.new(current_user, @transaction)
		if tc.code_check?
			if tc.credit_check? # @user.credits >= @transaction.credits
				if tc.product_check? # @product.amount_available >= @transaction.quantity
			    respond_to do |format|
			      if @transaction.purchase
			        format.html { redirect_to user_transaction_path(current_user, @transaction), 
			        													notice: "Thank you #{ current_user.first_name } for buying from #{ @vendor.business }. We hope you enjoy it! Feel free to make another purchase from #{ @vendor.business } or other Vendor sites here on WuDii" }
			        format.json { render action: 'show', status: :created, location: @transaction }
			      else
			        format.html { render action: 'new', error: 'Purchase failed. Please try again.' }
			        format.json { render json: @transaction.errors, status: :unprocessable_entity }
			      end
			    end 
			  else
			  	flash[:error] = 'Not enough product in stock. Please pick a lower quantity.'
		      render action: 'new'
			  end
		  else
		   	flash[:error] = 'Insufficient credits. Please add more on your profile page.'
	      render action: 'new'
		  end
	  else
	  	flash[:error] = 'You have entered an incorrect security code'
      render action: 'new'
    end
	end

	def authorize
		@user = User.find(params[:id])
		@transaction = Transaction.find(params[:transaction_id])
		if current_user == @user && @transaction.user == @user
			@transaction.pending = false
			@transaction.save
			flash[:notice] = "You have authorized this purchase from #{@transaction.vendor.business}"
			redirect_to :back
		else
			flash[:error] = "You cannot authorize that transaction!"
			redirect_to :back
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

		# def new_transaction
		# 	if vendor_signed_in?
		# 		flash[:error] = 'You need to be logged in as a User to verify a transaction.'
		# 		redirect_to current_vendor
		# 	end
		# end

		def depleted_code_pool
			if current_user && current_user.code_pool.length == 0
				flash[:error] = 'You have no more security codes remaining. Verifications unavailable.'
				redirect_to current_user
			end
		end

		def transaction_params
			params.require(:transaction).permit(:security_code, :code_position, :quantity, :pending, :paid)
		end
end
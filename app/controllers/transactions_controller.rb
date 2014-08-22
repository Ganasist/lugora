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
		@transaction = Transaction.new
		@product 		 = Product.find(params[:product_id])
		@vendor 		 = @product.vendor
	end

	def create
    @transaction 				= Transaction.new(transaction_params)
    @vendor 						= Vendor.find(params[:vendor_id])
    @transaction.vendor = @vendor
    @transaction.user 	= current_user

		if TransactionCheck.new(current_user, @transaction).check?
			if current_user.credits > @transaction.amount
		    respond_to do |format|
		      if @transaction.save
		        format.html { redirect_to user_transaction_path(current_user, @transaction), 
		        													notice: 'Verification was successful.' }
		        format.json { render action: 'show', status: :created, location: @transaction }
		      else
		        format.html { render action: 'new' }
		        format.json { render json: @transaction.errors, status: :unprocessable_entity }
		      end
		    end
		   else
		   	flash[:error] = 'You have insufficient credits. Please add more here.'
	      render action: 'new'
		   end
	  else
	  	flash[:error] = 'You have entered an incorrect security code'
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
			params.require(:transaction).permit(:user_id, 
																					:vendor_id, 
																					:security_code,
																					:code_position,
																					:amount, 
																					:disputed)
		end
end
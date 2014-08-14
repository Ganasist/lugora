class TransactionsController < ApplicationController
	before_action :depleted_code_pool
	before_action :verify_users_only, only: [:new, :create]
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
		@vendor 		 = Vendor.find(params[:vendor_id])
		@transaction = Transaction.new
		# authorize @transaction
	end

	def create
		# authorize @transaction
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
		def verify_transaction_owners
			@transaction = Transaction.find(params[:id])
			unless (current_user && current_user == @transaction.user) ||
						 (current_vendor && current_vendor == @transaction.vendor)
				flash[:error] = 'You do not have access to that transaction record.'
				redirect_to root_path
			end
		end

		def verify_users_only
			if current_vendor
				flash[:error] = 'You need to be logged in as a User to verify a transaction.'
				redirect_to current_vendor
			end
		end

		def depleted_code_pool
			if current_user && current_user.code_pool.length == 0
				flash[:error] = 'You have no more security codes remaining. Purchases unavailable.'
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
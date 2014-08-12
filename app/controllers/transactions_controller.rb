class TransactionsController < ApplicationController
	before_action :authenticate_user!
	before_action :depleted_code_pool

	def index		
	
	end

	def new
		@vendor 		 = Vendor.find(params[:vendor_id])
		@transaction = Transaction.new
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
		        													notice: 'Purchase was successful.' }
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

	def show
		if user_signed_in?
			@user = User.find(params[:user_id])
			@transaction = Transaction.find(params[:id])
		elsif vendor_signed_in?
			@vendor = current_vendor					
		end
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end

	private

		def depleted_code_pool
			if current_user.code_pool.length == 0
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
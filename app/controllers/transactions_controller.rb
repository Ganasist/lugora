class TransactionsController < ApplicationController
	before_action :authenticate_user!

	def index		
	
	end

	def new
		@vendor 		 = Vendor.find(params[:vendor_id])
		@transaction = Transaction.new
		@amount 		 = %w(100 1000 10000 100000 1000000).sample
		@code_number = current_user.code_pool.sample	
	end

	def create
		# current_user.code_pool.slice!(@code_number - 1)
	end

	def show
		
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end

	private

		def transaction_params
			params.require(:transaction).permit(:user_id, 
																					:vendor_id, 
																					:security_code, 
																					:amount, 
																					:disputed)
		end
end
class TransactionsController < ApplicationController

	def index		
	
	end

	def new
		
	end

	def create
		
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
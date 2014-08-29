class TokensController < ApplicationController

	def update
		if params[:token] == ""
			flash[:notice] = "Hello"
		else
			flash[:alert] = "World"
		end
		redirect_to current_user		
	end

	private

end

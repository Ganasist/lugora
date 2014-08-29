class TokensController < ApplicationController
	before_action :user_verify

	def update
		if params[:token] == ""
			flash[:notice] = "Hello"
		else
			flash[:alert] = "World"
		end
		redirect_to current_user		
	end

	private
		def user_verify
			unless current_user == @user
				flash[:alert] = "You aren't authorized to do that!"
				redirect_to current_user
			end
		end
end

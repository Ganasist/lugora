class TokensController < ApplicationController
	before_action :authenticate_user!
	before_action :user_verify, on: :update

	def update
		# @token = Token.new
		@user = User.find(params[:id])
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

		def token_params
			params.require(:token).permit(:user, :token)
		end
end
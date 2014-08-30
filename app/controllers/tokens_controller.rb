class TokensController < ApplicationController
	before_filter :authenticate_user!
	before_filter :user_verify, only: :update

	def update
		@token = Token.find_by(encrypted_token_code: params[:token_code])
		if @token && !@token.redeemed?
			respond_to do |format|
	      if Token.process(@token, current_user)
	        format.html { redirect_to current_user, notice: "#{ @token.credits } credits were added to your account!" }
	        format.json { head :no_content }
	      else
	        format.html { redirect_to current_user, alert: 'Transaction failed!' }
	        format.json { render json: @token.errors, status: :unprocessable_entity }
	      end
	    end
	  else
	    if @token && @token.redeemed?
	   		puts 'Token already redeemed'
     	elsif !@token
     		puts 'Token does not exist'
     	end
	     flash[:alert] = 'Invalid token!'
	     redirect_to current_user
	   end
	end

	private
		def user_verify
			unless current_user.id.to_s == params[:id]
				flash[:alert] = "You aren't authorized to do that!"
				redirect_to current_user
			end
		end
end
class UsersController < ApplicationController
  before_action :user_privacy

	def show
		@user = User.find(params[:id])
    @token = Token.new
    if params[:search] && params[:search] != ""
      @date         = params[:search].to_time.end_of_day
      if @date > Date.today + 1
        flash[:alert] = "You can't search for future transactions."
        redirect_to current_user
      else
        @transactions = Transaction.date_search(@user, @date).recent
      end
    else
      @transactions = @user.transactions
	  end
    @recent_transactions = @user.transactions.all.recent
  end

	private
    def user_privacy
      @user = User.find(params[:id])
      unless (user_signed_in? && current_user == @user) || current_admin_user
        if vendor_signed_in?
          flash[:alert] = "You can't access User profiles."
          redirect_to current_vendor
        else
          flash[:alert] = "You don't have access to other User profiles."
          redirect_to current_user
        end
      end
    end
    
		rescue_from ActiveRecord::RecordNotFound do |exception|      
      if user_signed_in?
        flash[:alert] = "You don't have access to other User profiles."
        redirect_to current_user || root_url
      elsif  vendor_signed_in?
        flash[:alert] = "You can't access User profiles."
        redirect_to current_vendor || root_url        
      else
        flash[:alert] = "You need to sign in first."
        redirect_to root_url
      end
    end    
end

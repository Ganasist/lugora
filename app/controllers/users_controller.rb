class UsersController < ApplicationController
  before_action :user_privacy

	def show
		@user = User.find(params[:id])
    if params[:search] && params[:search] != ""
      @date         = params[:search].to_time.end_of_day
      @transactions = Transaction.user_search(@user, @date)
    else
      @transactions = @user.transactions
	  end
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
        redirect_to current_user
      elsif  vendor_signed_in?
        flash[:alert] = "You can't access User profiles."
        redirect_to current_vendor        
      else
        flash[:alert] = "You need to sign in first."
        redirect_to root_url
      end
    end    
end

class UsersController < ApplicationController
	# before_action :authenticate_user!

	def show
		@user = User.find(params[:id])
    if params[:search] && params[:search] != ""
      @transactions = Transaction.search(@user, params[:search]).limit(10).order('created_at DESC')
    else
      @transactions = @user.transactions
	  end
  end

	private
		rescue_from ActiveRecord::RecordNotFound do |exception|
      if user_signed_in?
        redirect_to current_user
      else
        flash[:alert] = "You need to sign in or sign up before continuing."
        redirect_to root_url
      end
    end
end

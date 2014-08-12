class UsersController < ApplicationController
	# before_action :authenticate_user!

	def show
		@user = User.find(params[:id])
    @uuid_credit = @user.uuid_credits.build
    if params[:search] && params[:search] != ""
      @date = params[:search].to_time.end_of_day
      @transactions = Transaction.search(@user, @date).limit(10).order('created_at DESC')
    else
      @transactions = @user.transactions
	  end
  end

  def uuid_credit
    # @user = current_user
    # authorize @user
    respond_to do |format|
      if @uuid_credit.update(uuid_credit_params)
        # ItemBackgroundWorker.perform_async("device", @device.id, 'created', current_user.id)
        format.html { redirect_to current_user }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'show' }
        format.json { render json: @uuid_credit.errors, status: :unprocessable_entity }
      end
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

    def uuid_credit_params
      params.require(:uuid_credit).permit(:uuid)
    end
end

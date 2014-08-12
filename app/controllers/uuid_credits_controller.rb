# class UUIDCreditsController < ApplicationController

# 	def edit
# 		@user = current_user
		
# 	end

# 	def update
# 		@user = current_user
#     # authorize @user
#     @uuid_credit = UUID_Credit.where(uuid: @uuid_credit.uuid)
#     if @uuid_credit && !@uuid_credit.used?
#       respond_to do |format|
#         if @uuid_credit.update(uuid_credit_params)
#           # ItemBackgroundWorker.perform_async("device", @device.id, 'created', current_user.id)
#           format.html { redirect_to @user }
#           format.json { render action: 'show', status: :created, location: @user }
#         else
#           format.html { render action: 'show' }
#           format.json { render json: @uuid_credit.errors, status: :unprocessable_entity }
#         end
#       end
#     else
#       flash[:error] = 'You have entered an incorrect UUID credit code'
#       render action: 'show'
#     end		
# 	end

# 	protected
# 		rescue_from ActiveRecord::RecordNotFound do |exception|
#       if user_signed_in?
#         redirect_to current_user
#       else
#         flash[:alert] = "You need to sign in or sign up before continuing."
#         redirect_to root_url
#       end
#     end

#     def uuid_credit_params
#       params.require(:uuid_credit).permit(:user_id, :uuid)
#     end
# end
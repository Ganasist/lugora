class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_authenticity_redirect
  before_action :check_approval, except: [:edit, :update, :destroy]

  private
  	def invalid_authenticity_redirect
      redirect_to root_path
  	end

    def check_approval
      if user_signed_in? || vendor_signed_in?
        if !current_user.approved? || !current_vendor.approved?
          redirect_to edit_user_registration_path || edit_vendor_registration_path
          flash[:alert] = "You need to be Approved by an administrator before using WuDii."
        end
      end
    end

  	def after_sign_in_path_for(resource_or_scope)
			if resource_or_scope.is_a?(User)
	    	current_user
	    elsif resource_or_scope.is_a?(Vendor)
	    	current_vendor
      end
    end

	  def after_sign_out_path_for(resource_or_scope)
      if request.path == '/vendors/logout'
	  		new_vendor_session_path
	  	else
		  	root_path
	  	end
		end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private  
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

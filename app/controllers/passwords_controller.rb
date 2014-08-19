class PasswordsController < Devise::PasswordsController

  protected  
		def after_sending_reset_password_instructions_path_for(resource_name) 
	  	if request.path == '/users/password'
	    	root_path
	    else
	    	new_vendor_session_path
	    end  
	  end

		def after_resetting_password_path_for(resource)
	  	if request.path == '/users/password'
	    	current_user
	    else
	    	current_vendor
	    end  	
	  end
end
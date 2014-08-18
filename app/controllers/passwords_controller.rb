class PasswordsController < Devise::PasswordsController

  protected  
		def after_sending_reset_password_instructions_path_for(resource_name) 
	  	if request.path == '/users/password'
	  		puts 'hello1'
	    	root_path
	    else
	    	puts 'hello2'
	    	new_vendor_session_path
	    end  
	  end

		def after_resetting_password_path_for(resource)
	  	if request.path == '/users/password'
	  		puts 'hello2'
	    	current_user
	    else
	    	puts 'world2'
	    	current_vendor
	    end  	
	  end
end
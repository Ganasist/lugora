# class UnlocksController < Devise::PasswordsController

#   protected  
# 		def after_sending_unlock_instructions_path_for(resource) 
# 	  	if request.path == '/users/unlock'
# 	  		puts 'hello1'
# 	    	root_path
# 	    else
# 	    	puts 'world1'
# 	    	new_vendor_session_path
# 	    end  
# 	  end

# 		def after_unlock_path_for(resource)
# 	  	if request.path == '/users/unlock'
# 	  		puts 'hello2'
# 	    	current_user
# 	    else
# 	    	puts 'world2'
# 	    	current_vendor
# 	    end  	
# 	  end
# end
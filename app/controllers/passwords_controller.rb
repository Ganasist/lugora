class PasswordsController < Devise::PasswordsController

  protected
	  def after_sending_reset_password_instructions_path_for(resource_name)
	  	if request.path == '/vendors/password'
	  		new_vendor_session_path
	  	else
		  	root_path
	  	end
	  end
end
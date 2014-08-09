class Vendors::SessionsController < Devise::SessionsController
	before_action :configure_permitted_parameters
	before_action :authenticate_vendor!

	def new
		super
	end

	def create
		super
	end

	def destroy
		super
	end

	protected

  	def after_sign_out_path_for(resource_or_scope)
	    new_vendor_session_path
	  end

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, 
																															:password, 
																															:remember_me) }			
		end
end
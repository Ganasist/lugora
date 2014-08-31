class Vendors::RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters
	# prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
 #  prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy, :show]

	def index
		super
	end

	def show
		super
	end

	def new
		super
	end

	def edit
		super
	end

	# def create
	# 	super
	# end

	def update
		super
	end

	def destroy
		super
	end

	protected

		def after_inactive_sign_up_path_for(resource_or_scope)
	    new_vendor_session_path
		end

		def after_update_path_for(resource)
      current_vendor
    end

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name,
																															:last_name,
																															:business,
																															:email,
																															:url,
																															:phone_prefix,
																															:phone_number,																															
																															:image, 
																															:image_remote_url, 
																															:delete_image,
																															:street_address,
																															:city,
																															:state,
																															:postal_code, 
																															:password, 
																															:password_confirmation) }


			devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:approved,
																																		 :first_name,
																																		 :last_name,
																																		 :business,
																																		 :email,
																																		 :url,
																																		 :phone_prefix,
																																		 :phone_number,																															
																																		 :image, 
																																		 :image_remote_url, 
																																		 :delete_image,
																																		 :street_address,
																																		 :city,
																																		 :state,
																																		 :postal_code, 
																																		 :password, 
																																		 :password_confirmation,
																																		 :current_password) }

		end

end
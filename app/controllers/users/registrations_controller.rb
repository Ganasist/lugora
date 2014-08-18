class Users::RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters
	# prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
  # prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy, :show]

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

	def create
		super
	end

	def update
		super
	end

	def destroy
		super
	end

	protected

		def after_inactive_sign_up_path_for(resource_or_scope)
			current_user
		end

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name,
																															:last_name,
																															:occupation,
																															:email,
																															:phone_prefix,
																															:phone_number,
																															:street_address,
																															:city,
																															:state,
																															:postal_code, 
																															:password, 
																															:password_confirmation) }

			devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name,
																																		 :last_name,
																																		 :occupation,
																																		 :email,
																																		 :phone_prefix,
																																		 :phone_number,
																																		 :street_address,
																																		 :city,
																																		 :state,
																																		 :postal_code, 
																																		 :password, 
																																		 :password_confirmation, 
																																		 :current_password) }			
		end

end
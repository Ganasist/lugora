class Users::RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters

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

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password) }

			devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password) }			
		end

end
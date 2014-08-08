class Users::SessionsController < Devise::SessionsController
	before_action :configure_permitted_parameters
	before_action :authenticate_user!

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
			devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, 
																															:password, 
																															:remember_me) }			
		end
end
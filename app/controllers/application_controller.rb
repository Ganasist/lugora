class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  private
	  def after_sign_out_path_for(resource_or_scope)
     root_path
		end
end

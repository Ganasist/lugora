class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
	  def after_sign_out_path_for(resource_or_scope)
     root_path
		end

		def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore

      flash[:error] = I18n.t "pundit.#{policy_name}.#{exception.query}",
                            default: 'You cannot access that page.'
      redirect_to(current_user)
    end
end

# class SessionsController < Devise::SessionsController

#   def create
#     # try to authenticate as a User
#     self.resource = warden.authenticate(auth_options)
#     resource_name = self.resource_name
 
#     if resource.nil?
#       # try to authenticate as an Vendor
#       resource_name = :vendor
#       request.params[:vendor] = params[:user]
 
#       self.resource = warden.authenticate!(auth_options.merge(scope: :admvendorin_user))
#     end
 
#     set_flash_message(:notice, :signed_in) if is_navigational_format?
#     sign_in(resource_name, resource)
#     respond_with resource, :location => after_sign_in_path_for(resource)
#   end

#   protected
#     def configure_permitted_parameters
#       devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, 
#                                                               :password, 
#                                                               :remember_me) }     
#     end
# end
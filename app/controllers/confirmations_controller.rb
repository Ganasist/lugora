class ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    if resource.is_a?(User)
    	root_path
    elsif resource.is_a?(Vendor)
    	new_vendor_session_path
    else
	  	super
    end    	
  end
end
class UnlocksController < Devise::ConfirmationsController

  private

  def after_unlock_path_for(resource)
  	if resource.is_a?(User)
    	root_path
    elsif resource.is_a?(Vendor)
    	new_vendor_session_path
    else
	  	super
    end  	
  end
end
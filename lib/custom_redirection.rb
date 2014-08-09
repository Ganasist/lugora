class CustomRedirection < Devise::FailureApp
  def redirect_url
    if warden_options[:scope] == :user 
      root_path 
    elsif warden_options[:scope] == :vendor
      new_vendor_session_path
    else 
      new_admin_user_session_path 
    end 
  end
  def respond
    if http_auth?
     http_auth
    else
     redirect
    end
  end
 end
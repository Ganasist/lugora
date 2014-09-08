class SecurityCodesMailer < ActionMailer::Base

  def security_codes_mail(user_id, pdf)
  	@user = User.find(user_id)
  	mail(subject: "Security Codes for User ##{ @user.id }", 
  					from: "no-reply@wudii.com", 
  						to: "sidideas@gmail.com") do |format|
	    format.html
	    format.pdf do
	      attachments.inline["Security Codes for User ##{ @user.id }.pdf"] = pdf
	    end
	  end
  end
end
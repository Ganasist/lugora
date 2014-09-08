class TokenMailer < ActionMailer::Base

  def token_mail(token_id, pdf)
  	@token = Token.find(token_id)
  	mail(subject: "Token ##{ token_id } - (#{ @token.credits })", from: "no-reply@wudii.com", to: "sidideas@gmail.com") do |format|
	    format.html
	    format.pdf do
	      attachments.inline["Token ##{ token_id }.pdf"] = pdf
	    end
	  end
  end
end
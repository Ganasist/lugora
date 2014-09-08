class SecurityCodesPdfPrinter
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_ids)
    users = User.find(user_ids)
		# create an instance of ActionView, so we can use the render method outside of a controller
    av = ActionView::Base.new()
    av.view_paths = ActionController::Base.view_paths

    # need these in case your view constructs any links or references any helper methods.
    av.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end
    users.each do |user|
      html = av.render pdf: "User ##{ user.id }",
                      file: "#{ Rails.root }/app/admin/pdfs/security_pdf.html.erb",
                    layout: 'layouts/codes',
        disable_javascript: true,
            enable_plugins: false,
           locals: { user: user }

      pdf =  WickedPdf.new.pdf_from_string(html, margin: { top: 2,
                                                        bottom: 2,
                                                          left: 3,
                                                         right: 3 })

      SecurityCodesMailer.delay.security_codes_mail(user.id, pdf)
    end
  end
end
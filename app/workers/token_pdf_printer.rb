class TokenPdfPrinter
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(token_id)
    @token = Token.find(token_id)
		# create an instance of ActionView, so we can use the render method outside of a controller
    av = ActionView::Base.new()
    av.view_paths = ActionController::Base.view_paths

    # need these in case your view constructs any links or references any helper methods.
    av.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end
    render pdf: "Token ##{ @token.id }",
                file: "#{ Rails.root }/app/admin/pdfs/token_pdf.html.erb",
              layout: 'codes.html',
              page_height: '3.5in',
              page_width: '2in',
              margin: {  top: 2,
                      bottom: 2,
                        left: 3,
                       right: 3 },
         disposition: 'attachment',
  disable_javascript: true,
      enable_plugins: false
  end
end
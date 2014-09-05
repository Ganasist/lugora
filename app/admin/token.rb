ActiveAdmin.register Token do
  menu label: 'Tokens'

  config.per_page = 100

  scope :all
  scope :redeemed
  scope :not_redeemed
  scope :not_redeemed_not_printed

  permit_params :token_number, :token_value

  sidebar :batch_token_generation, only: :index do
    render("admin/tokenform")
  end

  filter :id
  filter :credits
  filter :encrypted_token_code
  filter :printed
  filter :user_id

  index do
    selectable_column
    column :id, sortable: true
    column :user
    column :encrypted_token_code, sortable: false do |token|
      token.encrypted_token_code.scan(/.{4}|.+/).join('-')
    end
    column :credits, sortable: true
    column :printed, sortable: true
    column :redeemed, sortable: true
    actions
  end

  batch_action :print do |selection|
    Token.find(selection).each do |token|
      print_token_path(token, format: 'pdf')
    end
    redirect_to :back
  end

  show do |token|
    attributes_table do
      row :id
      row :user
      row :encrypted_token_code do |token|
        token.encrypted_token_code.scan(/.{4}|.+/).join('-')
      end
      row :credits
      row :redeemed
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  action_item only: :show do
    link_to 'Print Token', print_token_path(token, format: 'pdf')
  end

  controller do
    before_action :authenticate_admin_user!

    def print_token
      @token = Token.find(params[:id])
      # TokenPdfPrinter.perform_async(@token.id)
      # redirect_to :back
      respond_to do |format|
        format.pdf do
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
    end

    def show
      @token = Token.find(params[:id])
    end

    def batch_token_create
      if Token.generator_check?(params[:token_quantity], params[:token_value])
        BatchTokenCreator.perform_async(params[:token_quantity], params[:token_value])
        flash[:notice] = "#{params[:token_quantity]} tokens worth #{params[:token_value]} credits are being generated."
        redirect_to admin_tokens_path
      else
        flash[:error] = "You must enter a token quantity between 100 - 5000 and value of at least 1000."
        redirect_to admin_tokens_path
      end
    end
  end
end
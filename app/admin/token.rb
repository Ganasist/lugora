ActiveAdmin.register Token do
  menu label: 'Tokens'

  scope :all
  scope :redeemed
  scope :not_redeemed

  permit_params :token_number, :token_value

  sidebar :batch_token_generation, only: :index do
    render("admin/tokenform")
  end

  filter :id
  filter :encrypted_token_code
  filter :user_id

   index do
    selectable_column
    column :id, sortable: true
    column :user
    column :encrypted_token_code, sortable: false do |token|
      token.encrypted_token_code.scan(/.{4}|.+/).join('-')
    end
    column :credits, sortable: :credits
    column :redeemed, sortable: true
    actions
  end

  show do |token|
    attributes_table do
      row :id
      row :user
      row :credits
      row :redeemed
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  action_item only: :show do
    link_to 'Print Token', admin_token_path(token, format: 'pdf') # if user.approved?
  end

  controller do
    before_action :authenticate_admin_user!

    def show
      @token = Token.find(params[:id])
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "Token ##{ @token.id }",
                file: "#{ Rails.root }/app/admin/pdfs/token_pdf.html.erb",
              layout: 'codes.html',
              margin: {  top: 8,
                      bottom: 8,
                        left: 10,
                       right: 10 },
         disposition: 'inline',
  disable_javascript: true,
      enable_plugins: false
        end
      end
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
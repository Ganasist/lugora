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

  batch_action :email do |selection|
    TokenPdfPrinter.perform_async(selection)
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

  controller do
    before_action :authenticate_admin_user!

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
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

  controller do
    before_action :authenticate_admin_user!
    def batch_token_create
      BatchTokenCreator.perform_async(params[:token_quantity], params[:token_value])
      flash[:notice] = "#{params[:token_quantity]} tokens worth #{params[:token_value]} credits are being generated."
      redirect_to admin_tokens_path
    end
  end
end
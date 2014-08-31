ActiveAdmin.register Token do
  menu label: 'Tokens'

  scope :all
  scope :redeemed
  scope :not_redeemed


  filter :id
  filter :encrypted_token_code
  filter :user_id

   index do
    selectable_column
    column :id, sortable: true
    column :user
    column :encrypted_token_code, sortable: false
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

end
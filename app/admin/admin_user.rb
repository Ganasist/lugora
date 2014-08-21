ActiveAdmin.register AdminUser do
  permit_params :email, :timeout, :password, :password_confirmation

  controller do
    skip_before_filter :authenticate_user!
    def create
      super do |format|
        redirect_to admin_root_path and return if resource.valid?
      end
    end
 
    def update
      super do |format|
        redirect_to admin_root_path and return if resource.valid?
      end
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  # filter :id
  # filter :email

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email
      f.input :timeout
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end

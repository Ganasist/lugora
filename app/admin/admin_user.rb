ActiveAdmin.register AdminUser do
  permit_params :email, :timeout, :password, :password_confirmation

  controller do
    def create
      create! { redirect_to :back and return }
    end
 
    def update
      update! { redirect_to :back and return }
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

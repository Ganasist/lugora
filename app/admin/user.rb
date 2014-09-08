ActiveAdmin.register User do
  menu label: 'Users'

  config.per_page = 100

  scope :all
  scope :confirmed
  scope :unconfirmed
  scope :approved
  scope :not_approved
  scope :locked
  scope :unlocked

  permit_params :first_name, :last_name, :occupation, :email, :phone_prefix, :phone_number,
                :street_address, :city, :state, :postal_code, :approved, :security_codes,
                :password, :password_confirmation

  filter :id
  filter :email
  filter :last_name
  filter :phone_number
  filter :created_at, label: 'Joined between'

  index do
    selectable_column
    column :id
    column :name, sortable: :last_name do |user|
      link_to(user.fullname, admin_user_path(user))
    end
    column :email do |user|
      mail_to(user.email, user.email)
    end
    column :approved
    column :confirmed?, sortable: :confirmed_at do |user|
      user.confirmed?
    end
    column :locked?, sortable: :locked_at do |user|
      user.access_locked?
    end
    actions
  end

  batch_action :email_codes do |selection|
    SecurityCodesPdfPrinter.perform_async(selection)
    redirect_to :back
  end

  batch_action :confirm do |selection|
    User.find(selection).each do |user|
      user.confirm!
    end
    redirect_to :back
  end

  batch_action :lock do |selection|
    User.find(selection).each do |user|
      user.lock_access!
    end
    redirect_to :back
  end

  batch_action :unlock do |selection|
    User.find(selection).each do |user|
      user.unlock_access!
    end
    redirect_to :back
  end

  batch_action :approve do |selection|
    User.find(selection).each do |user|
      user.approved = true
      user.save
    end
    redirect_to :back
  end

  batch_action :disapprove do |selection|
    User.find(selection).each do |user|
      user.approved = false
      user.save
    end
    redirect_to :back
  end

  batch_action :regenerate_codes do |selection|
    User.find(selection).each do |user|
      user.generate_security_codes
      user.save
    end
    redirect_to :back
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Details' do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :occupation
      f.input :street_address
      f.input :city
      f.input :state
      f.input :postal_code
      f.input :phone_prefix
      f.input :phone_number
      f.input :approved
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row :id
      row :confirmed_at do |user|
        user.confirmed? ? user.confirmed_at : "false"
      end
      row :approved do |user|
        user.approved? ? "true" : "false"
      end 
      row :locked do |user|
        user.access_locked? ? user.locked_at : "false"
      end
      row :name do |user|
        link_to(user.fullname, user)
      end
      row :email do |user|
        mail_to(user.email, user.email)
      end
      row :credits
      row :occupation
      row :phone_prefix
      row :phone_number
      row :street_address
      row :city
      row :state
      row :postal_code
      row :create_at
      row :updated_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :failed_attempts
      row :code_pool
    end
    render 'users/code_table'
    active_admin_comments
  end

  # action_item only: :show do
  #   link_to 'Print Codes', admin_user_path(user, format: 'pdf') # if user.approved?
  # end

  action_item only: :show do
    link_to 'Confirm User', confirm_user_admin_user_path(user), method: :post if !user.confirmed?
  end

  member_action :confirm_user, method: :post do
    user = User.find(params[:id])
    user.confirm! if !user.confirmed?

    flash[:notice] = "#{ user.fullname } has been confirmed"
    redirect_to admin_user_path(id: user.id)
  end

  action_item only: :show do
    link_to 'Unlock User', unlock_user_admin_user_path(user), 
                            method: :post if user.access_locked?
  end

  member_action :unlock_user, method: :post do
    user = User.find(params[:id])
    user.unlock_access!

    flash[:notice] = "#{ user.first_name } has been unlocked."
    redirect_to admin_user_path(id: user.id)
  end

  action_item only: :show do
    link_to 'Lock User', lock_user_admin_user_path(user), 
                            method: :post if !user.access_locked?
  end

  member_action :lock_user, method: :post do
    user = User.find(params[:id])
    user.lock_access!

    flash[:error] = "#{ user.first_name } has been locked."
    redirect_to admin_user_path(id: user.id)
  end

  action_item only: :show do
    link_to 'Regenerate codes', regenerate_codes_admin_user_path(user), method: :post
  end

  member_action :regenerate_codes, method: :post do
    user = User.find(params[:id])
    user.generate_security_codes

    flash[:notice] = "#{ user.first_name }'s codes are being regenerated. Refresh this page in a few seconds to see the new codes."
    redirect_to admin_user_path(id: user.id)
  end

  action_item only: :show do
    link_to 'Approve User', approve_user_admin_user_path(user), 
                            method: :post if !user.approved?
  end

  member_action :approve_user, method: :post do
    user = User.find(params[:id])
    user.approved = true
    user.save

    flash[:notice] = "#{ user.first_name } has been approved."
    redirect_to admin_user_path(id: user.id)
  end

  action_item only: :show do
    link_to 'Disapprove User', disapprove_user_admin_user_path(user), 
                               method: :post if user.approved?
  end 

  member_action :disapprove_user, method: :post do
    user = User.find(params[:id])
    user.approved = false
    user.save

    flash[:error] = "#{ user.first_name } has been disapproved."
    redirect_to admin_user_path(id: user.id)
  end

  controller do
    def show
      @user = User.find(params[:id])
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "User ##{ @user.id }",
                file: "#{ Rails.root }/app/admin/pdfs/security_pdf.html.erb",
              layout: 'codes.html',
              margin: {  top: 8,
                      bottom: 8,
                        left: 10,
                       right: 10 },
         disposition: 'attachment',
  disable_javascript: true,
      enable_plugins: false
        end
      end
    end

    def update
      user = params['user']

      # If we haven't set a password explicitly, we don't want it reset so 
      # don't pass those fields upstream and devise will ignore them
      if user && (user['password'] == nil || user['password'].empty?)
        user.delete('password')
        user.delete('password_confirmation')
      end

      update!
    end

    protected
      rescue_from ActiveRecord::RecordNotFound do |exception| 
        flash[:alert] = "User not found."
        redirect_to admin_users_path
      end
  end
end
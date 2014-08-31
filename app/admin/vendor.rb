ActiveAdmin.register Vendor do
  menu label: "Vendors"

  scope :all
  scope :confirmed
  scope :unconfirmed
  scope :approved
  scope :not_approved
  scope :locked
  scope :unlocked

  permit_params :first_name, :last_name, :business, :email, :phone_prefix, :phone_number,
                :street_address, :city, :state, :postal_code, :approved,
                :password, :password_confirmation

  filter :id
  filter :email
  filter :business
  filter :phone_number

  index do
    selectable_column
    column :id
    column :business do |vendor|
      link_to(vendor.business, vendor)
    end
    column :email do |vendor|
      mail_to(vendor.email, vendor.email)
    end
    column :approved
    column :confirmed?, sortable: :confirmed_at do |vendor|
      vendor.confirmed?
    end
    column :locked?, sortable: :locked_at do |vendor|
      vendor.access_locked?
    end
    actions
  end

  batch_action :confirm, 
                confirm: 'Are you sure you want to confirm all of these Vendor?' do |selection|
    Vendor.find(selection).each do |vendor|
      vendor.confirm!
    end
    redirect_to :back
  end

  batch_action :lock, 
                confirm: 'Are you sure you want to lock all of these vendors?' do |selection|
    Vendor.find(selection).each do |vendor|
      vendor.lock_access!
    end
    redirect_to :back
  end

  batch_action :unlock, 
                confirm: 'Are you sure you want to unlock all of these vendors?' do |selection|
    Vendor.find(selection).each do |vendor|
      vendor.unlock_access!
    end
    redirect_to :back
  end

  batch_action :approve, 
                confirm: 'Are you sure you want to approve all of these vendors?' do |selection|
    Vendor.find(selection).each do |vendor|
      vendor.approved = true
      vendor.save
    end
    redirect_to :back
  end

  batch_action :disapprove, 
                confirm: 'Are you sure you want to disapprove all of these vendors?' do |selection|
    Vendor.find(selection).each do |vendor|
      vendor.approved = false
      vendor.save
    end
    redirect_to :back
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :first_name
      f.input :last_name
      f.input :business
      f.input :email
      f.input :password
      f.input :password_confirmation
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

  show do |vendor|
    attributes_table do
      row :id
      row :confirmed_at do |vendor|
        vendor.confirmed? ? vendor.confirmed_at : "false"
      end
      row :approved do |vendor|
        vendor.approved? ? "true" : "false"
      end 
      row :locked do |vendor|
        vendor.access_locked? ? vendor.locked_at : "false"
      end
      row :vendor do |vendor|
        link_to(vendor.business, vendor)
      end
      row :email do |vendor|
        mail_to(vendor.email, vendor.email)
      end
      row :business
      row :phone_prefix
      row :phone_number
      row :street_address
      row :city
      row :state
      row :phone_number
      row :postal_code
      row :create_at
      row :updated_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :failed_attempts
    end
    active_admin_comments
  end

  action_item only: :show do
    link_to 'Vendor Profile', vendor_path(vendor)
  end

  action_item only: :show do
    link_to 'Confirm Vendor', confirm_vendor_admin_vendor_path(vendor), method: :post if !vendor.confirmed?
  end

  member_action :confirm_vendor, method: :post do
    vendor = Vendor.find(params[:id])
    vendor.confirm! if !vendor.confirmed?

    flash[:notice] = "#{ vendor.business } has been confirmed"
    redirect_to admin_vendor_path(id: vendor.id)
  end

  action_item only: :show do
    link_to 'Unlock Vendor', unlock_vendor_admin_vendor_path(vendor), 
                            method: :post if vendor.access_locked?
  end

  member_action :unlock_vendor, method: :post do
    vendor = Vendor.find(params[:id])
    vendor.unlock_access!

    flash[:notice] = "#{ vendor.business } has been unlocked."
    redirect_to admin_vendor_path(id: vendor.id)
  end

  action_item only: :show do
    link_to 'Lock Vendor', lock_vendor_admin_vendor_path(vendor), 
                            method: :post if !vendor.access_locked?
  end

  member_action :lock_vendor, method: :post do
    vendor = Vendor.find(params[:id])
    vendor.lock_access!

    flash[:error] = "#{ vendor.business } has been locked."
    redirect_to admin_vendor_path(id: vendor.id)
  end

  action_item only: :show do
    link_to 'Approve Vendor', approve_vendor_admin_vendor_path(vendor), 
                            method: :post if !vendor.approved?
  end

  member_action :approve_vendor, method: :post do
    vendor = Vendor.find(params[:id])
    vendor.approved = true
    vendor.save

    flash[:notice] = "#{ vendor.business } has been approved."
    redirect_to admin_vendor_path(id: vendor.id)
  end

  action_item only: :show do
    link_to 'Disapprove Vendor', disapprove_vendor_admin_vendor_path(vendor), 
                               method: :post if vendor.approved?
  end 

  member_action :disapprove_vendor, method: :post do
    vendor = Vendor.find(params[:id])
    vendor.approved = false
    vendor.save

    flash[:error] = "#{ vendor.business } has been disapproved."
    redirect_to admin_vendor_path(id: vendor.id)
  end

  controller do
    def update
      vendor = params['vendor']

      # If we haven't set a password explicitly, we don't want it reset so 
      # don't pass those fields upstream and devise will ignore them
      if vendor && (vendor['password'] == nil || vendor['password'].empty?)
        vendor.delete('password')
        vendor.delete('password_confirmation')
      end

      update!
    end

    protected
      rescue_from ActiveRecord::RecordNotFound do |exception| 
        flash[:alert] = "Vendor not found."
        redirect_to admin_vendors_path
      end 
  end
end

ActiveAdmin.register Vendor do
  menu label: "TF Vendors"

  scope :all
  scope :not_approved
  scope :approved

  permit_params :first_name, :last_name, :business, :email, :phone_prefix, :phone_number,
                :street_address, :city, :state, :postal_code, :approved

  filter :id
  filter :email
  filter :last_name
  filter :phone_number

  index do
    column :id
    column :name, sortable: :last_name do |vendor|
      vendor.fullname
    end
    column :email
    column :approved
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :email
      f.input :business
      f.input :street_address
      f.input :city
      f.input :state
      f.input :postal_code
      f.input :phone_number
      f.input :approved
    end
    f.actions
  end

  controller do

    protected
      rescue_from ActiveRecord::RecordNotFound do |exception| 
        flash[:alert] = "Vendor not found."
        redirect_to admin_vendors_path
      end 
  end
end

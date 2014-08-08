ActiveAdmin.register User do
  menu label: "TF Users"

  scope :all
  scope :not_approved
  scope :approved

  permit_params :first_name, :last_name, :occupation, :email, :phone_prefix, :phone_number,
                :street_address, :city, :state, :postal_code, :approved, :security_codes

  filter :id
  filter :email
  filter :last_name
  filter :phone_number

  index do
    selectable_column
    column :id
    column :name, sortable: :last_name do |user|
      user.fullname
    end
    column :email
    column :approved
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :occupation
      f.input :street_address
      f.input :city
      f.input :state
      f.input :postal_code
      f.input :phone_number
      f.input :approved
    end
    f.actions
  end

  batch_action :disapprove_all do |selection|
    User.find(selection).each do |user|
      user.approved = false
      user.save
    end
    redirect_to :back
  end

  batch_action :approve_all do |selection|
    User.find(selection).each do |user|
      user.approved = true
      user.save
    end
    redirect_to :back
  end

  batch_action :regenerate_codes_all, 
                confirm: "Are you sure you want to regenerate codes for all of these Users?" do |selection|
    User.find(selection).each do |user|
      user.generate_security_codes
      user.save
    end
    redirect_to :back
  end

  action_item only: :show do
    link_to "View User's page", user_path(user)
  end

  action_item only: :show do
    link_to "Regenerate codes", regenerate_codes_admin_user_path(user), method: :post
  end

  action_item only: :show do
    link_to 'Approve User', approve_user_admin_user_path(user), method: :post if !user.approved?
  end

  action_item only: :show do
    link_to 'Disapprove User', disapprove_user_admin_user_path(user), method: :post if user.approved?
  end

  member_action :regenerate_codes, method: :post do
    user = User.find(params[:id])
    user.generate_security_codes

    flash[:notice] = "#{ user.first_name }'s codes are being regenerated. Refresh this page in a few seconds to see the new codes."
    redirect_to admin_user_path(id: user.id)
  end

  member_action :approve_user, method: :post do
    user = User.find(params[:id])
    user.approved = true
    user.save

    flash[:notice] = "#{ user.first_name } has been approved."
    redirect_to admin_user_path(id: user.id)
  end

  member_action :disapprove_user, method: :post do
    user = User.find(params[:id])
    user.approved = false
    user.save

    flash[:error] = "#{ user.first_name } has been disapproved."
    redirect_to admin_user_path(id: user.id)
  end

  controller do
    def update
      user = params["user"]

      # If we haven't set a password explicitly, we don't want it reset so 
      # don't pass those fields upstream and devise will ignore them
      if user && (user["password"] == nil || user["password"].empty?)
        user.delete("password")
        user.delete("password_confirmation")
      end

      update!
    end
  end
end
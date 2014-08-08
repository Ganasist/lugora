ActiveAdmin.register User do

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
                confirm: "Are you sure you want to regenerate codes for all of these users?" do |selection|
    User.find(selection).each do |user|
      user.generate_security_codes
      user.save
    end
    redirect_to :back
  end

  # member_action :approve do
  #   User.find(params[:id]).generate_security_codes
  #   redirect_to :back
  # end

  # member_action :regenerate_codes, :method => :put do
  #   user = User.find(params[:id])
  #   user.generate_security_codes
  #   # redirect_to { :action => :show }, { :notice => "Codes regenerated for #{ user.fullname }!" }
  # end
end
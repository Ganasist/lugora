ActiveAdmin.register Transaction do
  menu label: 'Transactions'

  scope :all
  scope :pending
  scope :not_pending
  scope :paid
  scope :not_paid

  permit_params :paid

  filter :id, label: 'Transaction ID'
  filter :user_id, label: 'User ID'
  filter :vendor_id, label: 'Vendor ID'

   index do
    selectable_column
    column :id, sortable: true
    column :user, sortable: true
    column :vendor, sortable: true
    column :credits, sortable: true
    column :pending, sortable: true
    column :paid, sortable: true
    column :created_at
    column :updated_at
    actions
  end

  show do |transaction|
    attributes_table do
      row :id
      row :user
      row :vendor
      row :product
      row :quantity
      row :credits
      row :pending do |transaction|
        transaction.pending? ? "Still pending" : "Cleared"
      end
      row :paid do |transaction|
        transaction.paid? ? "Paid" : "Not paid"
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  controller do
    
    def scoped_collection
      Transaction.includes([:user, :vendor])
    end
  end
end
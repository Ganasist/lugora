ActiveAdmin.register Transaction do
  menu label: 'Transactions'

  scope :all
  scope :pending
  scope :not_pending

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

  # action_item only: :show do
  #   link_to 'Pay Vendor', pay_vendor_admin_transaction_path(vendor), method: :post if !transaction.paid?
  # end

  # member_action :pay_vendor, method: :post do
  #   transaction = Transaction.find(params[:id])
  #   vendor = transaction.vendor
  #   transactions = vendor.transactions.where('pending = ? AND paid = ?', nil, nil)
  #   transactions.each do |t|
  #     t.paid = true
  #     t.save!
  #   end
  #   vendor.credits += transaction.credits
  #   flash[:notice] = "#{ vendor.business } has been paid #{ transaction.credits } credits."
  #   vendor.save!
  #   redirect_to admin_transaction_path(id: transaction.id)
  # end

  controller do
    
    def scoped_collection
      Transaction.includes([:user, :vendor])
    end
  end
end
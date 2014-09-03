class TransactionAuthorize
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    outstanding_transactions = Transaction.where('pending = ? AND created_at > ?', true, 3.days.ago).unscoped
	  
	  outstanding_transactions.find_each do |transaction|
	    transaction.pending = false
      transaction.save
	  end
  end
end
class StaleConfirmRemoval
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    users = User.where('confirmed_at is ? AND confirmation_sent_at <= ?', nil, 1.day.ago)
	  users.each do |user|
	    user.destroy
	  end

	  vendors = Vendor.where('confirmed_at is ? AND confirmation_sent_at <= ?', nil, 1.day.ago)
	  vendors.each do |vendor|
	    vendor.destroy
	  end
  end
end
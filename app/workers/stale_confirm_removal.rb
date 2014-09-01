class StaleConfirmRemoval
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    stale_members = User.never_confirmed + Vendor.never_confirmed
	  
	  stale_members.each do |stale_member|
	    stale_member.destroy
	  end
  end
end
# Included in User, Vendor
module Scopes
	extend ActiveSupport::Concern
	included do
		scope :not, ->(scope_name) { where(send(scope_name).where_values.reduce(:and).not) }
		scope :not_approved, -> { where(approved: false) }
		scope :approved, -> { where(approved: true) }
		scope :confirmed, lambda { where !({confirmed_at: nil}) }
		scope :unconfirmed, lambda { where ({confirmed_at: nil}) }
		scope :unlocked, -> { where(locked_at: nil) }
		scope :recent, -> { order(created_at: :desc)}
	end
end
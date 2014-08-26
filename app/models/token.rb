class Token < ActiveRecord::Base
  belongs_to :user
  attr_encrypted :token
end

class Vendor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable
end

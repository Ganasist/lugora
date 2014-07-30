class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :lockable,
  			 :timeoutable, :recoverable, :rememberable, :trackable, :validatable
end

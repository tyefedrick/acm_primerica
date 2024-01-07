class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_roles
  has_many :roles, through: :user_roles
  
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable
end

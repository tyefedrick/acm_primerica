class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_roles
  has_many :roles, through: :user_roles

  has_many :favorites
  has_many :rvps, through: :favorites
  
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable

  has_many :downloaded_pdfs
  has_many :pdfs, through: :downloaded_pdfs
end

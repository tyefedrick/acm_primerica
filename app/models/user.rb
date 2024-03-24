class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validate :must_be_primerica_email
  
  has_many :user_roles
  has_many :roles, through: :user_roles

  has_many :favorites
  has_many :rvps, through: :favorites
  
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable

  has_many :downloaded_pdfs
  has_many :pdfs, through: :downloaded_pdfs

  private

  def must_be_primerica_email
    domain = email.split('@').last.downcase if email.present?
    errors.add(:email, 'must be a primerica.com account') unless domain == 'primerica.com'
  end
end

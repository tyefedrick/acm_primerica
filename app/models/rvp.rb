class Rvp < ApplicationRecord
  enum proctor_status: { not_proctor: 0, proctor: 1 }
  has_many :pdfs
  has_many :favorites
  has_many :users, through: :favorites
  default_scope -> {where(archived_at: nil)}
  scope :archived, -> {unscoped.where.not(archived_at: nil)}

  def formatted_name
    "#{first_name} #{last_name} - #{solution_number}"
  end

  def favorite_by_user?(user)
    user.favorites.exists?(rvp: self)
  end

  def archive
    self.update!(archived_at: Time.now)
  end

  def unarchive
    self.update!(archived_at: nil)
  end

  def archived?
    self.archived_at.present?
  end

  def toggle_proctor_status!
    if not_proctor?
      update(proctor_status: :proctor)
    else
      update(proctor_status: :not_proctor)
    end
  end
end

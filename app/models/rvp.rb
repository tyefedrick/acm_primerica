class Rvp < ApplicationRecord
    def formatted_name
        "#{first_name} #{last_name} - #{solution_number}"
      end
      has_many :pdfs

      has_many :favorites
      has_many :users, through: :favorites

      def favorite_by_user?(user)
        favorites.exists?(user_id: user.id)
      end
end

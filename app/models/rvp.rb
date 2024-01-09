class Rvp < ApplicationRecord
    def formatted_name
        "#{first_name} #{last_name} - #{solution_number}"
      end
      has_many :pdfs
end

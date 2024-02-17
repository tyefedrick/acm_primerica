class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :rvp

  # Define the name method to return the desired attribute from the associated Rvp
  def name
    rvp.first_name + ' ' + rvp.last_name
  end

end
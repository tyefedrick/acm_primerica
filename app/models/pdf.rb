class Pdf < ApplicationRecord
  belongs_to :rvp

  # Add this line to attach a file to the Pdf model
  has_one_attached :file
end
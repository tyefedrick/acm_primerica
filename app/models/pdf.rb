class Pdf < ApplicationRecord
  belongs_to :rvp
  has_one_attached :file
  attr_accessor :full_name
  has_many :downloaded_pdfs
  has_many :users, through: :downloaded_pdfs  # Use has_many :users through :downloaded_pdfs

  def full_name
    # Extract the full name from the PDF file name
    # You may need to adjust this based on how your file names are structured
    file_name = self.file.filename.to_s
    match = file_name.match(/^(.*?) AMC Form \d{4}-\d{2}-\d{2}\.pdf/)

    if match
      Rails.logger.info("File Name: #{file_name}")
      Rails.logger.info("Match Data: #{match.inspect}")
      return match[1]
    else
      Rails.logger.error("Full Name Not Found for File Name: #{file_name}")
      # If no match is found, return a default value or handle it as needed
      return "Full Name Not Found"
    end
  end

  def formatted_date
    # Extract the formatted date from the PDF file name
    # You may need to adjust this based on how your file names are structured
    file_name = self.file.filename.to_s
    match = file_name.match(/(\d{4}-\d{2}-\d{2})\.pdf/)

    if match
      return Date.parse(match[1])
    else
      # If no match is found, return nil or handle it as needed
      return nil
    end
  end

  def downloaded_by?(user)
    downloaded_pdfs.exists?(user: user)
  end
end
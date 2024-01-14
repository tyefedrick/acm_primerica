class AddFormattedDateToPdfs < ActiveRecord::Migration[7.0]
  def change
    add_column :pdfs, :formatted_date, :date
  end
end

class AddUploadedAtToPdfs < ActiveRecord::Migration[7.0]
  def change
    add_column :pdfs, :uploaded_at, :datetime
  end
end

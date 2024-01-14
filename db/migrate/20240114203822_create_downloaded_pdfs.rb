class CreateDownloadedPdfs < ActiveRecord::Migration[7.0]
  def change
    create_table :downloaded_pdfs do |t|
      t.references :pdf, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
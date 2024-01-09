class CreatePdfs < ActiveRecord::Migration[7.0]
  def change
    create_table :pdfs do |t|
      t.references :rvp, null: false, foreign_key: true

      t.timestamps
    end
  end
end

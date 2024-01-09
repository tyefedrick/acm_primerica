class CreateRvps < ActiveRecord::Migration[7.0]
  def change
    create_table :rvps do |t|
      t.string :first_name
      t.string :last_name
      t.string :solution_number

      t.timestamps
    end
  end
end

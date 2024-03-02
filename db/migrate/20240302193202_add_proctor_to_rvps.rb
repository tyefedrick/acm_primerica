class AddProctorToRvps < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:rvps, :proctor)
      add_column :rvps, :proctor, :boolean, default: false
    end
  end
end

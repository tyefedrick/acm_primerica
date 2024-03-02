class AddProctorStatusToRvps < ActiveRecord::Migration[6.0]
  def change
    add_column :rvps, :proctor_status, :integer

    reversible do |dir|
      dir.up do
        Rvp.update_all(proctor_status: 0) # Set default value for existing records
      end
    end

    remove_column :rvps, :proctor
  end
end
class AddArchivedAtToRvp < ActiveRecord::Migration[7.0]
  def change
    add_column :rvps, :archived_at, :datetime
  end
end

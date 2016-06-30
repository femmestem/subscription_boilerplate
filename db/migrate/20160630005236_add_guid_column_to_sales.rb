class AddGuidColumnToSales < ActiveRecord::Migration
  def up
    add_column :sales, :guid, :string
  end

  def down
    remove_column :sales, :guid
  end
end

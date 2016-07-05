class ChangeProductPriceToInteger < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.change :price, :integer, null: false
    end
  end

  def self.down
    change_table :products do |t|
      t.change :price, :integer, precision: 10, scale: 2, null: false
    end
  end
end

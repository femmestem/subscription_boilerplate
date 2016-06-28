class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :permalink
      t.text :description
      t.integer :price, precision: 10, scale: 2, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

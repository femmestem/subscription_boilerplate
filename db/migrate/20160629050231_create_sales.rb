class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :email
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class AddStateMachineFieldsToSales < ActiveRecord::Migration
  def change
    change_table :sales do |t|
      t.string :state
      t.string :stripe_token
      t.date :card_expiration
      t.text :error
      t.integer :fee_amount
      t.integer :amount
    end
  end
end

class AddStripePaymentGatewayTokenToSales < ActiveRecord::Migration
  def up
    add_column :sales, :stripe_id, :string
  end

  def down
    remove_column :sales, :stripe_id
  end
end

class AddPreferredPaymentEngineToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :preferred_payment_engine, :string
  end
end

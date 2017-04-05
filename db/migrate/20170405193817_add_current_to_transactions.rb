class AddCurrentToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :current, :boolean, default: false
  end
end

class AddBankBilletUrlToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :bank_billet_url, :string, default: ''
  end
end
